return {
	-- LSP for TypeScript and JavaScript
	{
		"LazyVim/LazyVim",
		opts = {
			extras = {
				"lazyvim.plugins.extras.lang.typescript",
				"lazyvim.plugins.extras.lang.json",
				"lazyvim.plugins.extras.linting.eslint",
			},
		},
	},

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
