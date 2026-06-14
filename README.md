# oil-grapple.nvim

Display [grapple.nvim](https://github.com/cbochs/grapple.nvim) tags as virtual text in [oil.nvim](https://github.com/stevearc/oil.nvim).

![](https://github.com/user-attachments/assets/0a531de6-1f7c-4c60-aa85-ee7569dfe5c5)

## Installation

```lua
vim.pack.add({ src = 'https://github.com/0x0003/oil-grapple.nvim' })
require('oil-grapple').setup()
```

### `setup({opts})`

| option     | type     | default         | description                      |
|------------|----------|-----------------|----------------------------------|
| `prefix`   | `string` | `''`            | String prepended to the tag name |
| `highlight`| `string` | `'EndOfBuffer'` | Highlight group for the tag text |

Configuration used in the screenshot: `require('oil-grapple').setup({ prefix = '', highlight = 'WarningMsg' })`

