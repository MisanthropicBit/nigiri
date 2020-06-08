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

* If 'yes', show only the last part of the path: `set -g theme_short_path (yes|no)`
* If 'yes', show a house emoji when in the home directory: `set -g theme_home_emoji (yes|no)`
