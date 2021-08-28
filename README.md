# Nigiri 🍣

A theme for the [fish shell](https://fishshell.com/) inspired by [oh-my-fish](https://github.com/oh-my-fish/theme-default)'s default theme.

![Nigiri screenshot](https://github.com/MisanthropicBit/nigiri/raw/master/screenshot.png)

## Install

Clone the repository and add the following to your `.config.fish`.

```bash
source <location-of-nigiri-files>/fish_prompt.fish
source <location-of-nigiri-files>/fish_right_prompt.fish
```

If the computed prompt length is wrong, please see
[`fish_emoji_width`](https://fishshell.com/docs/current/index.html?highlight=unicode#special-variables)
and check your terminal's settings.

## Options

Enable options by setting them to `'yes'`.

* `theme_short_path`: Show only the last part of the path.
* `theme_home_emoji`: Show a house emoji 🏡when in the home directory.
* `theme_nerd_fonts`: Use [nerd fonts](https://www.nerdfonts.com/#home) symbols.
* `theme_end_space`: Add a space at the end of the prompt. Useful with wide
  unicode characters in some terminals.
