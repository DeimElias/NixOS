vim.opt.makeef = "/tmp/neovim-##"
vim.opt.errorformat = "%E%.%#error: %m,%Z%.%#at %f:%l:%c:%.%#"
vim.opt.shellpipe = " e> "
vim.opt.makeprg = "nixos-rebuild build --flake /home/chimuelo/.config/dotfiles\\#tower"
