# Zenbook Duo keys

**A GNOME Shell extension for the ASUS Zenbook Duo UX8406. It gives a function
to two keys of the keyboard that need the desktop, and gives each touchscreen
its screen. The keys need the keyboard package from
[asus-zenbook-duo-ux8406](https://github.com/cceelen/asus-zenbook-duo-ux8406).**

## Keys

- The key right of F12 switches the lower screen on and off. The change is for
  the session only; the saved `monitors.xml` does not change. With the keyboard
  on the lower screen, the key does nothing.
- F8 swaps the windows of the two screens.

The package
[asus-zenbook-duo-ux8406-keyboard-bpf](https://github.com/cceelen/asus-zenbook-duo-ux8406/blob/main/keyboard-bpf/README.md)
is necessary: it makes the keyboard send these keys, as `XF86Launch9` and `F19`.
It is a HID-BPF program, which only the package manager of your distribution can
install. The extension cannot install it.

## Touch

Without a setting, GNOME gives the two touchscreens to the upper screen: the two
screens have the same size and say that they are the same monitor. A touch on
the lower screen then acts on the upper screen.

The extension sets the screen for each touchscreen and for each pen, in GNOME's
setting `output` of the device (`org.gnome.desktop.peripherals.touchscreen` and
`.tablet`), with the connector as the fourth value. It reads the ids of the
touch controllers from the machine. It does not change a setting that you made,
and the settings stay when the extension is disabled. To go back to GNOME's own
choice:

```sh
dconf reset -f /org/gnome/desktop/peripherals/touchscreens/
dconf reset -f /org/gnome/desktop/peripherals/tablets/
```

Touch is tested on the UX8406CA. The pens are not tested.

## Use

Install the extension from extensions.gnome.org, or with the zip of a
[release](https://github.com/cceelen/gnome-extension/releases):

```sh
gnome-extensions install asus-zenbook-duo-ux8406-keys@cceelen.github.io.shell-extension.zip
```

Log in again, then enable the extension:

```sh
gnome-extensions enable asus-zenbook-duo-ux8406-keys@cceelen.github.io
```

For the keys, install the keyboard package: the
[README of asus-zenbook-duo-ux8406](https://github.com/cceelen/asus-zenbook-duo-ux8406#installation)
tells how. A distribution package of this extension from that project has the
same UUID; remove it.

On a machine that is not a UX8406, the extension binds no key and sets nothing.

GNOME Shell 45 to 50 is declared. Only GNOME Shell 50 is tested.

## Test

```sh
node --test gnome-keys/tests/*.test.js
```

`layout.js` and `touch.js` have the logic and no GNOME imports; `display.js`
calls `org.gnome.Mutter.DisplayConfig`. For the files that the two extensions
share, and for an installation from the tree, refer to
[CONTRIBUTING.md](../CONTRIBUTING.md#an-extension-from-the-tree).

`tests/verify.js` is a manual check in a GNOME session. It asks Mutter to verify
the current layout and the layout that the key requests. It applies nothing.

```sh
gjs -m tests/verify.js
```
