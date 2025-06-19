return {
  {
    -- This ensures that all your formatters are installed by Mason.
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettier", -- For your web development files
        "stylua", -- For Lua files
        "clang-format", -- ADDED: For C and C++ files
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    -- Make sure conform runs after the tools are installed
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- This table maps file types to their formatters.
      formatters_by_ft = {
        -- Your existing formatters (unchanged)
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },

        -- ADDED: New formatters for C/C++
        c = { "clang_format" },
        cpp = { "clang_format" },
      },

      -- Your existing format_on_save settings (unchanged)
      -- This will now also apply to C++ files.
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    },
  },
}

