{ final }:
# lua
''
      vim.g.mapleader = " "       -- Need to set leader before lazy for correct keybindings

      -- Save undo history
      vim.opt.undofile = true

      -- colorscheme
      require('tokyonight').setup({ transparent = true })
      vim.cmd.colorscheme('tokyonight')

      vim.o.relativenumber = true
      vim.o.number = true
      -- Enable break indent
      vim.opt.breakindent = true

      -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      vim.opt.ignorecase = true
      vim.opt.smartcase = true

      -- Move Line
      vim.keymap.set('n', '<C-k>', '<cmd>mo .-2<CR>')
      vim.keymap.set('n', '<C-j>', '<cmd>mo .+1<CR>')
      vim.keymap.set('v', '<C-k>', ":'< mo .-2<CR>gv=gv")
      vim.keymap.set('v', '<C-j>', ":'<,'> mo '>+1<CR>gv=gv")

      -- Indent lines
      vim.keymap.set('v', '>', ">gv", {noremap = true})
      vim.keymap.set('v', '<', "<gv", {noremap = true})

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
  	-- tabs
  	vim.opt.expandtab = true
  	vim.opt.softtabstop = 4
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4

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
      	callback = function()
      		vim.lsp.buf.format()
      	end,
      })

      --- Telescope setup
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = 'Telescope grep inner word' })
      vim.keymap.set('v', '<leader>fs', builtin.grep_string, { desc = 'Telescope grep selected' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope Fuzzy find in Buffer' })

      --- Harpoon setup
      local harpoon = require("harpoon")
  	harpoon:setup()
      vim.keymap.set("n","<leader>a", function() harpoon:list():add() end,
    		  { desc = "Add file to harpoon" })
      vim.keymap.set("n","<leader>v", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    		  { desc = "Harpoon-ed files" })
      vim.keymap.set("n","<S-H>", function() harpoon:list():select(1) end, { desc = "Harpoon-ed file 1", noremap = true })
      vim.keymap.set("n","<S-J>", function() harpoon:list():select(2) end, { desc = "Harpoon-ed file 2", noremap = true })
      vim.keymap.set("n","<S-K>", function() harpoon:list():select(3) end, { desc = "Harpoon-ed file 3", noremap = true })
      vim.keymap.set("n","<S-L>", function() harpoon:list():select(4) end, { desc = "Harpoon-ed file 4", noremap = true })



      vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

      vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {desc = 'Copy to system clipboard'})
      vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', {desc = 'Paste from system clipboard'})
      vim.keymap.set({'n', 'v'}, ':', 'q:i', {noremap = true})
      vim.keymap.set('n', '<C-L>', '<cmd>Ex<CR>', {desc = 'Open Netrw'})
      vim.keymap.set('n', '<leader>l', '<cmd>let @+ = @%<CR>', {desc = 'Copy path to cipboard'})


      --- Add ./Lua directory to VimRintimePath so LazyVim can read lua files
      vim.opt.runtimepath:append("${final.neovim-conf}")

      require("lazy").setup(
      	{
      		performance = {
      			reset_packpath = false,
      			rtp = {
      				reset = false
      			}
      		},
      		dev = {
      			path = "${final.vimUtils.packDir final.myNeovim.passthru.packpathDirs}/pack/myNeovimPackages/start",
      			patterns = { "" }, 
      		},
      		install = {
      			missing = false
      		},
      		spec = {
      			{ import = "plugins" }
      		}
      	}
      )
''
