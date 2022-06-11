# `consult-everything`

Use [Consult](https://github.com/minad/consult) to read results from [Everything](https://www.voidtools.com/support/everything/command_line_interface/).

## Requirements

- Windows 10
- [Everything command line interface](https://www.voidtools.com/support/everything/command_line_interface/)
- A recent version of Emacs for Windows.

## Installation

Install from Github via [straight.el](https://github.com/radian-software/straight.el) until the software is available on MELPA or ELPA. The package depends on consult.el and orderless.el.

```
(use-package consult-everything
  :straight (consult-everything :host github :repo "jthaman/consult-everything"))
```

## Recommendation

Install the [embark](https://github.com/oantolin/embark) package to open files externally from the minibuffer, rather than in Emacs.

![](pic.png)
