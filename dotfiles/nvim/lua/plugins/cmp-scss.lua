-- https://github.com/mmolhoek/cmp-scss

return {
    'mmolhoek/cmp-scss',
    config = function()
        function ReloadScss()
            require("lazy.core.loader").reload("cmp-scss")
        end

        -- this is VERY slow
        -- local group = vim.api.nvim_create_augroup("CustomCmpScss", { clear = true })
        -- vim.api.nvim_create_autocmd("BufWritePost", {
        --     group = group,
        --     pattern = "*.scss",
        --     callback = function()
        --         ReloadCmpScss()
        --     end
        -- })
        --
        vim.api.nvim_create_user_command('ReloadScss', ReloadScss, {})
    end
}
