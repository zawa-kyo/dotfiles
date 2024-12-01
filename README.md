# dotfiles

Personal collection of dotfiles for system configuration and customization.

## Enabling Pre-Hook for Protecting Sensitive Information

This pre-hook helps prevent accidental commits of sensitive information, such as passwords or API keys. Follow these steps to set up pre-commit for your repository.

```sh
# Install poetry
$ pip install poetry

# Enable and install pre-commit
$ poetry install
$ poetry run pre-commit install
```

### Notes

- Ensure that your repository includes a `pyproject.toml` file with pre-commit listed as a development dependency.
- If you have existing Git hooks, pre-commit will run in migration mode by default. Use the -f option to overwrite existing hooks and use only pre-commit.
