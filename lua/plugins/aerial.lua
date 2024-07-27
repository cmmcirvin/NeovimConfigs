local plugin = {'stevearc/aerial.nvim'}

function plugin.config()
  require("aerial").setup({
    on_attach = function(bufnr)
      vim.keymap.set("n", "[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "]", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
  })
  vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
end

return plugin
