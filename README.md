# GNOME Shell extensions

[![CI](https://github.com/cceelen/gnome-extension/actions/workflows/ci.yml/badge.svg)](https://github.com/cceelen/gnome-extension/actions/workflows/ci.yml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/cceelen/gnome-extension/badge)](https://scorecard.dev/viewer/?uri=github.com/cceelen/gnome-extension)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/15452/badge)](https://www.bestpractices.dev/projects/15452)
[![codecov](https://codecov.io/github/cceelen/gnome-extension/graph/badge.svg)](https://codecov.io/github/cceelen/gnome-extension)
[![Plumber Score](https://score.getplumber.io/github.com/cceelen/gnome-extension.svg)](https://score.getplumber.io/github.com/cceelen/gnome-extension)

**Two GNOME Shell extensions, published on extensions.gnome.org. Rotation turns
the built-in screens of a laptop when it stands on its side. Keys gives a
function to two keys of the ASUS Zenbook Duo UX8406 and gives each of its
touchscreens its screen. They are tested on a UX8406CA with Fedora 44 and GNOME
50.**

| Extension                                            | For                | Needs                                                                                    |
| ---------------------------------------------------- | ------------------ | ---------------------------------------------------------------------------------------- |
| [Built-in screen rotation](gnome-rotation/README.md) | Any laptop         | GNOME Shell 45 or later, iio-sensor-proxy                                                |
| [Zenbook Duo keys](gnome-keys/README.md)             | Zenbook Duo UX8406 | GNOME Shell 45 or later; for the keys, the keyboard package of [asus-zenbook-duo-ux8406] |

The extensions came from [asus-zenbook-duo-ux8406], which has the other parts
for the UX8406 (the guard, the second screen, the keyboard program) as
distribution packages.

## Where to start

| You want to                                  | Go to                                                  |
| -------------------------------------------- | ------------------------------------------------------ |
| Install an extension                         | [Installation](#installation)                          |
| Report a result or a problem                 | [CONTRIBUTING.md](CONTRIBUTING.md#report-your-results) |
| Build, test or change the code               | [CONTRIBUTING.md](CONTRIBUTING.md#build-and-test)      |
| Make a release, or check the origin of a zip | [docs/releases.md](docs/releases.md)                   |
| Report a vulnerability                       | [SECURITY.md](SECURITY.md)                             |

## Installation

For Rotation, check first that the sensor gives the right orientation; that is
set for the whole system, not in the extension. Its README says
[how](gnome-rotation/README.md#check-the-sensor-first).

From extensions.gnome.org, with the Extensions app or the web page. Or with the
zip of a [release](https://github.com/cceelen/gnome-extension/releases):

```sh
gnome-extensions install builtin-screen-rotation@cceelen.github.io.shell-extension.zip
```

Log in again, then enable the extension in the Extensions app or with
`gnome-extensions enable <uuid>`.

The distribution packages `gnome-shell-extension-builtin-screen-rotation` and
`gnome-shell-extension-asus-zenbook-duo-ux8406-keys` of
[asus-zenbook-duo-ux8406] have the same UUIDs. A copy in your home directory
takes precedence over the package, so the two do not conflict; remove the
package to have one copy only.

The GNOME Shell versions in `metadata.json` are declared. CI loads each zip in
GNOME Shell 46 and 50; only GNOME 50 is tested on the hardware.

[asus-zenbook-duo-ux8406]: https://github.com/cceelen/asus-zenbook-duo-ux8406
