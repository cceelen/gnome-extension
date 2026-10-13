# Contributing

**You can help in three ways: tell if an extension operates on your laptop,
report a problem, or send a change. All three go through
[GitHub](https://github.com/cceelen/gnome-extension/issues). Only a UX8406CA
with Fedora 44 is tested on the hardware, so a report from another laptop or
distribution is the contribution that helps most.**

## Report your results

Open an issue with the form of the extension, also when it operates. Include:

- Laptop model (`cat /sys/class/dmi/id/product_name`).
- Distribution and GNOME Shell version (`gnome-shell --version`).
- The extension version (`gnome-extensions info <uuid>`).
- What operates and what does not.

## Report a problem

Give the data of [Report your results](#report-your-results), then the output of
the commands for the extension.

Rotation:

```sh
journalctl -b -g builtin-screen-rotation
gdctl show
monitor-sensor
```

Keys:

```sh
journalctl -b -g asus-zenbook-duo-ux8406-keys
gdctl show
```

`gdctl` is part of GNOME 48 and later. `monitor-sensor` is part of
iio-sensor-proxy: turn the laptop while it runs, then stop it with Ctrl+C.

## Build and test

Tools: `node` 22 or later, `zip`, `unzip`, `glib-compile-schemas`; for the Shell
test, `docker` or `podman`.

```sh
node --test gnome-*/tests/*.test.js tests/*.test.js
build-aux/pack.sh gnome-rotation dist
build-aux/pack.sh gnome-keys dist
pre-commit run --all-files
```

- `build-aux/pack.sh` writes `dist/<uuid>.shell-extension.zip`, the file for
  extensions.gnome.org. The same tree gives the same zip.

- The Shell test loads the zips in a headless GNOME Shell in a container, and
  disables them. CI runs it with Ubuntu 24.04 (GNOME Shell 46) and 26.04 (50):

  ```sh
  docker run --rm -v "$PWD:/src:ro" ubuntu:26.04 \
      /src/tests/shell/container.sh /src/dist/*.zip
  ```

- Formats and lints are [pre-commit](https://pre-commit.com) hooks. Run
  `pre-commit install` one time.

### An extension from the tree

Install the zip for your user, log in again, and enable the extension. Remove a
distribution package of the extension first: it has the same UUID.

```sh
build-aux/pack.sh gnome-rotation dist
gnome-extensions install --force dist/builtin-screen-rotation@cceelen.github.io.shell-extension.zip
```

The two extensions use the same files for the display state: `state.js` and
`display.js` in each `extension/` directory are links to `gnome-common/`, and
the zip has a copy. Their tests share the fixtures in `gnome-common/tests`.

## Rules for changes

- The title of a pull request is a
  [Conventional Commits](https://www.conventionalcommits.org/) title: it makes
  the changelog and the version. `fix:` gives a patch release, `feat:` a minor
  release.
- `disable()` undoes all that `enable()` did, and nothing is done before
  `enable()`: the
  [review guidelines](https://gjs.guide/extensions/review-guidelines/review-guidelines.html)
  of extensions.gnome.org reject the extension otherwise.
- Logic goes in modules without GNOME imports, with tests that use plain data.
- The documents use Simplified Technical English. A claim without evidence is
  marked as not verified.

## Layout

| Path              | What                                                    |
| ----------------- | ------------------------------------------------------- |
| `gnome-rotation/` | The rotation extension, its tests and a manual tool     |
| `gnome-keys/`     | The keys extension, its schema, tests and a manual tool |
| `gnome-common/`   | The display state that both use, and the test fixtures  |
| `build-aux/`      | The script that makes the zips                          |
| `tests/`          | The tests of the zips and the Shell test                |
