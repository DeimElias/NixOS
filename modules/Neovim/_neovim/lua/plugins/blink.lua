return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{ "jmbuhr/otter.nvim", opts = {} },
		},
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = false,
						kind_resolution = {
							enabled = false,
						},
						semantic_token_resolution = {
							enabled = false,
						},
					},
				},
				menu = {
					draw = {
						columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
					}
				}
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { 'snippets', 'dadbod', 'buffer' },
					quarto = { 'lsp', 'snippets', 'otter', 'path' },
					r = { 'lsp', 'snippets', 'path' },
				},
				providers = {
					otter = {
						name = "otter",
						module = "blink.compat.source",
						opts = {},
					},
					dadbod = { name = "dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	}
}
