# Watchman

Installs the latest upstream Watchman release from Facebook and adds it to the container PATH.

## Example usage

```json
{
  "features": {
    "ghcr.io/your-org/watchman:latest": {
      "version": "latest"
    }
  }
}
```

You can also pin a specific release tag:

```json
{
  "features": {
    "ghcr.io/your-org/watchman:latest": {
      "version": "v2026.08.03.00"
    }
  }
}
```

## Options

- `version`: Watchman release tag to install. Defaults to `latest`.

## Notes

- This feature installs from the official Watchman source release on GitHub instead of the stale distro package.
- The install builds Watchman into `/usr/local` and exposes the `watchman` binary on PATH.
