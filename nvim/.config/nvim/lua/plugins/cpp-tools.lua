-- This configures the C++ Language Server and Treesitter parser.

return {
  {
    -- Link: https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Add "clangd" to the list of tools Mason should automatically install.
      table.insert(opts.ensure_installed, "clangd")
    end,
  },

  {
    -- nvim-lspconfig is the core plugin for configuring Language Servers.
    -- Link: https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    opts = {
      -- This tells lspconfig to start the "clangd" server when you open a C or C++ file.
      servers = {
        clangd = {},
      },
    },
  },

  {
    -- nvim-treesitter provides advanced syntax highlighting and code parsing.
    -- It's much more accurate than traditional methods.
    -- Link: https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add "cpp" to the list of languages for Treesitter to install a parser for.
      table.insert(opts.ensure_installed, "cpp")
    end,
  },
}
