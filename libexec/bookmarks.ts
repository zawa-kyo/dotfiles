type Bookmark = [browser: string, location: string, title: string, url: string];

// Return whether a parsed value is a JSON object.
function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

// Normalize one field so each bookmark remains a single TSV record.
function normalizeField(value: string): string {
  return value.replace(/[\t\r\n]+/g, " ");
}

// Add one bookmark while removing duplicate records.
function addBookmark(entries: Map<string, Bookmark>, bookmark: Bookmark): void {
  const normalized: Bookmark = [
    normalizeField(bookmark[0]),
    normalizeField(bookmark[1]),
    normalizeField(bookmark[2]),
    normalizeField(bookmark[3]),
  ];
  entries.set(normalized.join("\t"), normalized);
}

// Collect Chrome URL nodes from a parsed Bookmarks file.
function collectChromeBookmarks(
  node: unknown,
  profile: string,
  entries: Map<string, Bookmark>,
): void {
  if (Array.isArray(node)) {
    for (const child of node) collectChromeBookmarks(child, profile, entries);
    return;
  }
  if (!isRecord(node)) return;

  if (node.type === "url" && typeof node.url === "string" && node.url) {
    const title =
      typeof node.name === "string" && node.name ? node.name : node.url;
    addBookmark(entries, ["Chrome", profile, title, node.url]);
    return;
  }

  for (const child of Object.values(node))
    collectChromeBookmarks(child, profile, entries);
}

// Convert a Safari plist to JSON with the macOS system utility.
async function readSafariPlist(path: string): Promise<unknown> {
  const process = Bun.spawn(["plutil", "-convert", "json", "-o", "-", path], {
    stdout: "pipe",
    stderr: "pipe",
  });
  const [stdout, stderr, exitCode] = await Promise.all([
    new Response(process.stdout).text(),
    new Response(process.stderr).text(),
    process.exited,
  ]);
  if (exitCode !== 0) {
    throw new Error(stderr.trim() || `plutil exited with status ${exitCode}`);
  }
  return JSON.parse(stdout);
}

// Collect Safari leaf bookmarks from converted plist data.
function collectSafariBookmarks(
  node: unknown,
  entries: Map<string, Bookmark>,
): void {
  if (Array.isArray(node)) {
    for (const child of node) collectSafariBookmarks(child, entries);
    return;
  }
  if (!isRecord(node)) return;

  if (
    node.WebBookmarkType === "WebBookmarkTypeLeaf" &&
    typeof node.URLString === "string" &&
    node.URLString
  ) {
    const uri = isRecord(node.URIDictionary) ? node.URIDictionary : undefined;
    const title =
      (typeof uri?.title === "string" && uri.title) ||
      (typeof node.Title === "string" && node.Title) ||
      node.URLString;
    addBookmark(entries, ["Safari", "Bookmarks", title, node.URLString]);
    return;
  }

  for (const child of Object.values(node))
    collectSafariBookmarks(child, entries);
}

// Parse the requested browser source and print stable TSV records.
async function main(args: string[]): Promise<void> {
  const [browser, ...values] = args;
  const entries = new Map<string, Bookmark>();

  if (browser === "chrome" && values.length === 2) {
    const [profile, path] = values;
    collectChromeBookmarks(await Bun.file(path).json(), profile, entries);
  } else if (browser === "safari" && values.length === 1) {
    collectSafariBookmarks(await readSafariPlist(values[0]), entries);
  } else {
    throw new Error(
      "Usage: bun bookmarks.ts chrome PROFILE PATH | safari PATH",
    );
  }

  for (const record of [...entries.keys()].sort()) console.log(record);
}

await main(Bun.argv.slice(2)).catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exit(1);
});
