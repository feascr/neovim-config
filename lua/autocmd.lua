local autocmd_group = vim.api.nvim_create_augroup("feascr-autocmd", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = autocmd_group,
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = autocmd_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
