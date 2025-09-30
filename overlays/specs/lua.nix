{ final }:
# lua
''
  vim.g.mapleader = " " -- Need to set leader before lazy for correct keybindings
  vim.opt.breakindent = true

  -- Save undo history
  vim.opt.undofile = true
  vim.cmd.colorscheme('tokyonight-night')
  vim.o.relativenumber = true
  -- Enable break indent

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Move Line
  vim.keymap.set('n', '<C-k>', '<cmd>mo .-2<CR>')
  vim.keymap.set('n', '<C-j>',  '<cmd>mo .+1<CR>')
  vim.keymap.set('v', '<C-k>', ":'< mo .-2<CR>gv")
  vim.keymap.set('v', '<C-j>', ":'<,'> mo '>+1<CR>gv")

  -- Decrease update time
  vim.opt.updatetime = 250
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Page relocate 
  vim.keymap.set('n', '<C-D>', '<C-D>zz')
  vim.keymap.set('n', '<C-U>', '<C-U>zz')

  -- Highlight line
  vim.opt.cursorline = true

  -- Set cursror type 
  vim.opt.guicursor = 'n-v-c:block'
  -- Keep signcolumn on by default
  vim.opt.signcolumn = 'yes'
  -- Set window border 
  vim.opt.winborder = 'rounded'

  -- TIP: Disable arrow keys in normal and insert mode
  vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
  vim.keymap.set('i', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('i', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('i', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('i', '<down>', '<cmd>echo "Use j to move!!"<CR>')


  -- Preview substitutions live, as you type!
  vim.opt.inccommand = 'split'
  vim.opt.scrolloff = 15
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })
  vim.api.nvim_create_autocmd('BufWritePre', {
  	desc = 'Autoformat on save',
  	callback = function ()
  		vim.lsp.buf.format()
  	end,
  })

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  vim.keymap.set('n', '<leader>fr', builtin.live_grep, { desc = 'Telescope live grep' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Telescope buffers' })
  vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
  vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope Fuzzy find in Buffer' })

  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  require("lazy").setup(
     {
          performance = {
              reset_packpath = false,
              rtp = {
                  reset = false
              }
          },
          dev = {
              path = "${final.vimUtils.packDir final.neovim.passthru.packpathDirs}/pack/myNeovimPackages/start",
  	    patterns = {""}, -- Specify that all of our plugins will use the dev dir. Empty string is a wildcard!
          },
              -- Safeguard in case we forget to install a plugin with Nix
          install = {
              missing = false
          },
          spec = {
  	{
    'jiaoshijie/undotree',
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { '<leader>u', ':UndotreeToggle<CR>', desc = "UndoTree" },
    },
  },
  {
    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      ---@type Flash.Config
      opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
    },
  },
  	  { -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter', -- Sets the loading event to 'VimEnter'
      opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.opt.timeoutlen
        delay = 0,
        icons = {
          -- set icon mappings to true if you have a Nerd Font
          mappings = vim.g.have_nerd_font,
          -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
          -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
          keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-…> ',
            M = '<M-…> ',
            D = '<D-…> ',
            S = '<S-…> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            ScrollWheelDown = '<ScrollWheelDown> ',
            ScrollWheelUp = '<ScrollWheelUp> ',
            NL = '<NL> ',
            BS = '<BS> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
          },
        },
  },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
''
