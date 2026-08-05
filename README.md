# Dev Container Feature: Watchman

This repository provides a devcontainer feature for installing Facebook Watchman from the official upstream release instead of the stale distro package.

## Usage

```json
{
  "features": {
    "ghcr.io/your-org/watchman:latest": {
      "version": "latest"
    }
  }
}
```

## Notes

- Uses the current upstream Watchman release from GitHub.
- Builds and installs into `/usr/local`.
- Keeps the `watchman` binary available on PATH for the devcontainer user.

This project is based on the Dev Container feature template and current feature conventions.
