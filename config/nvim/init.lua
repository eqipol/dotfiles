vim.opt.number = true          -- номера строк
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Устанавливаем <leader> = пробел (space)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '   -- опционально, для локальных маппингов по файлу

-- Установка lazy.nvim (плагин-менеджер)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Тема catppuccin frappe
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "frappe" })
      vim.cmd.colorscheme "catppuccin"
    end
  },
-- Красивая строка снизу
{
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },  -- иконки (очень рекомендуются)
  config = function()
    require('lualine').setup {
      options = {
        theme = 'catppuccin',          -- автоматически берёт frappe, если выбрана тема
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'dashboard', 'alpha' },  -- не показывать на стартовых экранах
      },
      sections = {
        lualine_a = { 'mode' },          -- ← здесь будет красивый режим (NORMAL / INSERT и т.д.)
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    }
  end,
},
-- Предпросмотр маркдауна
{
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- mini нужен для некоторых фич
  config = function()
    require('render-markdown').setup({
      heading = { enabled = true, icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' } }, -- красивые иконки для заголовков
      code = { enabled = true, style = 'full' },
      checkbox = { enabled = true },
    })
  end,
},
  -- Для markdown — очень полезно
  -- Файловый менеджер (опционально)
{
  "nvim-tree/nvim-tree.lua",
  version = "*",  -- или "*" для последней стабильной
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local api = require("nvim-tree.api")

    -- Функции для hjkl-навигации (очень популярный рецепт из wiki/discussions)
    local function on_attach(bufnr)
      local opts = function(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Загружаем дефолтные маппинги
      api.config.mappings.default_on_attach(bufnr)

      -- hjkl как в vim + Finder-style
      local function smart_h()
        local node = api.tree.get_node_under_cursor()
        if node.nodes and node.open then
          api.node.open.edit()  -- закрыть, если открыта
        else
          api.node.navigate.parent()  -- иначе вверх к родителю
        end
      end

      local function smart_l()
        local node = api.tree.get_node_under_cursor()
        if node.nodes and not node.open then
          api.node.open.edit()  -- открыть, если закрыта
        elseif node.nodes and node.open then
          api.node.navigate.parent()  -- если уже открыта — можно ничего, или спуститься дальше
        else
          api.node.open.edit()  -- файл — открыть
        end
      end

      vim.keymap.set("n", "h", smart_h, opts("Smart h (collapse or parent)"))
      vim.keymap.set("n", "l", smart_l, opts("Smart l (expand or open)"))
      vim.keymap.set("n", "<Left>", smart_h, opts("Smart Left"))
      vim.keymap.set("n", "<Right>", smart_l, opts("Smart Right"))

      -- Дополнительно: Enter всегда открывает файл/папку
      vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))

      -- Переключение фокуса (очень удобно!)
      -- <leader>e теперь будет "toggle focus": если на дереве → назад к файлу, иначе → фокус на дерево (не закрывая)
      local function toggle_focus()
        if vim.bo.filetype == "NvimTree" then
          vim.cmd("wincmd p")  -- перейти к предыдущему окну (файлу)
        else
          api.tree.focus()     -- фокус на дерево (если открыто — просто переключает)
        end
      end

      vim.keymap.set("n", "<leader>e", toggle_focus, { desc = "NvimTree: Toggle Focus" })
    end

    -- Основная настройка
    require("nvim-tree").setup({
      on_attach = on_attach,

      view = {
        side = "left",
        width = 35,
        mappings = {
          list = {},  -- дефолтные + наши выше
        },
      },

      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },

      filters = {
        dotfiles = false,  -- показывать .hidden файлы
      },

      git = {
        enable = true,
        ignore = false,
      },

      update_focused_file = {
        enable = true,          -- дерево автоматически выделяет текущий открытый файл
        update_cwd = false,
      },

      diagnostics = {
        enable = true,
      },
    })
  end,

  -- Загружать по хоткею (лениво)
  keys = {
    { "<leader>e", function() require("nvim-tree.api").tree.focus() end, desc = "NvimTree Focus/Toggle" },
  },
},
  -- Telescope для поиска заметок
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
})

-- Горячие клавиши (примеры)
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
-- Toggle render-markdown для текущего буфера
vim.keymap.set('n', '<leader>md', ':RenderMarkdown toggle<CR>', { desc = 'Toggle Markdown Render' })

-- Переключение раскладки (Wayland/Hyprland)
require("rus-kbd")
