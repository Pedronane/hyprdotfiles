return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Carica i colori pywal
        vim.cmd("silent! source ~/.cache/wal/colors-wal.vim")
        local color3 = vim.g.color3 or "#ffaa00"
        local color4 = vim.g.color4 or "#00aaff"
        local color5 = vim.g.color5 or "#aa00ff"
        local color6 = vim.g.color6 or "#00ffaa"
        local color9 = vim.g.color9 or "#ff4444"

        -- Evidenziazioni personalizzate
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = color9, bold = true })
        vim.api.nvim_set_hl(0, "AlphaClock", { fg = color6, bold = true })
        vim.api.nvim_set_hl(0, "AlphaButton", { fg = color4 })
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = color5, bold = true })

        -- Orologio aggiornato ogni secondo
        local clock = {
            type = "text",
            val = os.date(" %H:%M:%S"),
            opts = { position = "center", hl = "AlphaClock" },
        }

        vim.loop.new_timer():start(0, 1000, vim.schedule_wrap(function()
            clock.val = os.date(" %H:%M:%S")
            pcall(alpha.redraw)
        end))

        local logo = {
            "⠀⠀⠀⠀⠀⠀⢀⡴⢾⣶⣴⠚⣫⠏⠉⠉⠛⠛⢭⡓⢶⣶⠶⣦⡀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⣰⠋⡀⣠⠟⢁⣾⠇⠀⣀⣷⠀⠀⠓⣝⠂⠙⣆⢄⢻⡞⢢⠀⠀⠀",
            "⠀⠀⠀⠀⢠⡇⢸⢡⠃⢠⡞⠁⠀⣰⡟⠉⢦⣄⠀⠈⢆⠀⢻⣾⡄⢧⢸⠀⠀⠀",
            "⠀⠀⠀⠀⢸⠀⡇⡌⠀⡞⠀⢀⣴⡋⠀⠀⠀⣙⣷⡀⠘⡄⠘⣿⣧⢸⣼⣥⠀⠀",
            "⣀⣀⣀⣀⣞⣰⠁⡇⠀⣧⢴⡛⠛⠁⠀⠀⠀⠉⠉⡙⡦⡇⠀⣿⣸⣼⣿⣇⣀⣀",
            "⠳⢽⣷⠺⡟⡿⣯⡇⠰⣧⢩⣭⣥⠀⠀⠀⠀⢠⣭⣥⠁⡀⠀⣿⡟⣴⠶⢁⡨⠊",
            "⠀⠀⠉⢳⢦⣅⠘⣿⣄⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⢀⣏⣳⡇⢴⡞⠁⠀",
            "⠀⠀⠀⣼⢸⡅⢹⣿⣿⣾⣟⠀⠀⠠⣀⢄⡠⠀⠀⠠⡚⣿⡿⣿⢻⠁⢹⣷⡀⠀",
            "⠀⠀⠸⡏⠸⡇⢼⣿⡿⠟⠛⠓⣦⣄⣀⣀⣀⣀⡤⠴⠿⢿⡟⠛⠺⣦⣬⣗⠀⠀",
            "⠀⠀⢰⡇⠀⡇⠸⡏⠀⠀⢰⠋⠙⠛⠛⠉⠉⢹⠀⠀⠀⠀⡇⠀⠀⣿⣿⣿⣟⡃",
            "⠀⡐⣾⠀⡀⢹⠀⣿⣄⠀⢸⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⢠⣇⠀⠀⣿⣿⣿⣛⡃",
            "⠀⣾⣿⠀⡇⠘⡄⢸⣿⠆⠈⡇⠀⠀⠀⠀⠈⢉⠃⠀⣰⡾⠻⠃⢰⣿⣿⣛⡋⠀",
            "⠀⣿⣿⡆⢷⠀⢧⠈⣿⠤⠤⣇⠀⠀⠀⠀⢀⣸⣠⢾⠟⠓⡶⢤⣾⣿⣿⣟⣓⠀",
        }

        dashboard.section.clock = clock
        dashboard.section.header.val = logo
        dashboard.section.header.opts.hl = "AlphaHeader"

        dashboard.section.buttons.val = {
            dashboard.button( "f", "󰱼  > Find file", ":lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files' } })<CR>"),
            dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
            dashboard.button( "o", "󱞁  > Obsidian" , ":e ~/Appunti/Home.md<CR>"),
            dashboard.button( "O", "󱞁  > Obsidian search" , ":cd ~/Appunti | Telescope find_files<CR>"),
            dashboard.button( "c", "  > Config" , ":cd ~/.config/nvim | Telescope find_files<CR>"),
            dashboard.button( "h", "  > Settings" , ":cd ~/.config/hypr | Telescope find_files<CR>"),
            dashboard.button( "q", "  > Quit", ":qa<CR>"),
        }

        dashboard.config.layout = {
            { type = "padding", val = 5 },
            dashboard.section.header,
            { type = "padding", val = 3 },
            dashboard.section.clock,
            { type = "padding", val = 3 },
            dashboard.section.buttons,
        }

        alpha.setup(dashboard.config)
    end,
}

