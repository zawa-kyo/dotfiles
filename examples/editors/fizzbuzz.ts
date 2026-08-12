// FIXME: Remove unused imports
import fs from "fs";
import path from "path";

/**
 * Prints "Fizz", "Buzz", or "FizzBuzz" for numbers from 1 to n.
 * - "Fizz" for numbers divisible by 3.
 * - "Buzz" for numbers divisible by 5.
 * - "FizzBuzz" for numbers divisible by both 3 and 5.
 * - Otherwise, prints the number itself.
 *
 * @param n - The upper limit of the range (inclusive).
 */
function fizzBuzz(n: number): void {
  for (let i = 1; i <= n; i++) {
    if (i % 15 === 0) {
      console.log("FizzBuzz");
    } else if (i % 3 === 0) {
      console.log("Fizz");
    } else if (i % 5 === 0) {
      console.log("Buzz");
    } else {
      console.log(i);
    }
  }
}

// Test cases:
// - Correct: fizzBuzz(15)
// - Error: fizzBuzz("15") (Type error)
fizzBuzz(15);

// TODO: Fix Type error
fizzBuzz("15");
