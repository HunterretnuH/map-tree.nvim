# map-tree

## Description

Map tree can be used to generate a keybinding listing in new buffer.

## Example
```
MAPPING     DESCRIPTION
<C-BS>      Delete words with Ctrl + Backspace
<C-S-q>     Force Quit
<C-h>       Help - map of all keybindings
<C-n>       Disable search highlight
<C-q>       Quit
<C-s>       Save buffer
    <C-s>       Save all buffers
    s           Save all buffers
<leader>    LEADER
    <ESC>       Exit terminal
    c           CONFIG
        d           Change working dir to current file location
        e           Edit vimrc - init.lua
        l           Source vimrc - init.lua
    d           DELETE
        m           Regex to clear all carriage returns at the EOL in whole buffer
        w           Regex to clear whitespaces at the EOL in whole buffer
    p           Paste into selection
    r           RELOAD
        m           Reload modeline
```

## Usage:
1. Register keybindings using `function M.register(lhs, desc)`.
2. Map `function M.open()` to keybinding and use it to open new buffer with keybindings listing.

## Installation (with [lazy.nvim](https://github.com/folke/lazy.nvim))
```lua
{
  "HunterretnuH/map-tree.nvim",
  config = function()
    require("map-tree").setup()
  end
}
```

