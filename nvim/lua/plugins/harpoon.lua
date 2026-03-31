return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		settings = {
			save_on_toggle = true,
		},
	},
	keys = {
		{ "<leader>a", function() require("harpoon"):list():add() end,                                    desc = "Add file to harpoon" },
		{ "<leader>v", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon-ed files" },
		{ "<S-H>",     function() require("harpoon"):list():select(1) end,                                desc = "Harpoon-ed file 1",  noremap = true },
		{ "<S-J>",     function() require("harpoon"):list():select(2) end,                                desc = "Harpoon-ed file 2",  noremap = true },
		{ "<S-K>",     function() require("harpoon"):list():select(3) end,                                desc = "Harpoon-ed file 3",  noremap = true },
		{ "<S-L>",     function() require("harpoon"):list():select(4) end,                                desc = "Harpoon-ed file 4",  noremap = true },
	}
}
