local plugin = {"kevinhwang91/nvim-ufo"}

plugin.dependencies = {
  {"kevinhwang91/promise-async"}
}
plugin.enabled = true
plugin.event = BufRead

function plugin.config()
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 100
  vim.o.foldenable = true

  vim.keymap.set("n", "<space>", "za")
  vim.keymap.set("v", "<space>", "zf")
  local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" 󰁂 %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
  end

  require("ufo").setup({
    open_fold_hl_timeout = 0,
    fold_virt_text_handler = handler,
    provider_selector = function(bufnr, filetype, buftype)
      return {'lsp', 'indent'}
    end
  })
end

return plugin
