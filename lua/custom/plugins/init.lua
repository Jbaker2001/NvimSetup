-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  priority = 1000,
  config = function()
    local configs = require 'nvim-treesitter.config'

    configs.setup {
      ensure_installed = { 'go' },
      sync_install = false,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    }

    -- FAIL-SAFE AUTOCOMMAND:
    -- Forces Neovim's native engine to latch onto Go files instantly on load
    vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPost', 'BufNewFile' }, {
      pattern = { 'go' },
      callback = function(args)
        -- Delays execution for a split millisecond so the buffer loads first
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(args.buf) then
            vim.treesitter.start(args.buf, 'go')
          end
        end)
      end,
    })
  end,
}
