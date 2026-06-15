local M = {}

local ns = vim.api.nvim_create_namespace('oil-grapple')

---@alias config { prefix?: string, highlight?: string }
local config

---@param buffer integer
local function refresh_buf(buffer)
  vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)
  local dir = require('oil').get_current_dir(buffer)
  if not dir then return end

  for n = 1, vim.api.nvim_buf_line_count(buffer) do
    local entry = require('oil').get_entry_on_line(buffer, n)
    if entry and entry.name then
      local tag = require('grapple').name_or_index({ path = require('grapple.path').join(dir, entry.name) })
      if tag then
        vim.api.nvim_buf_set_extmark(buffer, ns, n - 1, 0, {
          virt_text = { { config.prefix .. tostring(tag), config.highlight } },
          virt_text_pos = 'eol',
          hl_mode = 'combine',
        })
      end
    end
  end
end

local function refresh_all()
  vim
      .iter(vim.api.nvim_list_bufs())
      :filter(function(buf) return vim.bo[buf].filetype == 'oil' and vim.api.nvim_buf_is_valid(buf) end)
      :each(refresh_buf)
end

---@param opts config
function M.setup(opts)
  config = vim.tbl_deep_extend('force', {
    prefix = '',
    highlight = 'EndOfBuffer',
  }, opts or {})

  local group = vim.api.nvim_create_augroup('GrappleOilTag', { clear = true })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'OilEnter',
    group = group,
    callback = function(ev)
      local buf = ev.data and ev.data.buf
      if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_call(buf, function() refresh_buf(buf) end)
      end
    end,
  })

  for _, pattern in ipairs({ 'OilMutationComplete', 'GrappleUpdate' }) do
    vim.api.nvim_create_autocmd('User', {
      pattern = pattern,
      group = group,
      callback = refresh_all,
    })
  end
end

return M

