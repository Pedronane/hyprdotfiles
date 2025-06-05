return {
    "AlphaTechnolog/pywal.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        -- Set up pywal and load the colors
        require("pywal").setup()

    end,
}

