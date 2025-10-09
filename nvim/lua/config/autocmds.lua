        vim.api.nvim_create_autocmd('FileType', {
      pattern = {"python", "nix", "r", "quarto", "lua", "markdown", "html", "nu"},
      callback = function() vim.treesitter.start() end,
    })

