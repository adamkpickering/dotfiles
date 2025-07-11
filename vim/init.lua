-- ===========================================
-- Language-Specific Settings (using Autocommands)
-- ===========================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set up leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup lazy.nvim and define plugins directly here
require("lazy").setup({
	-- nvim-cmp: Autocompletion framework
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',       -- LSP completion source
			-- Add more cmp sources as desired, e.g., 'hrsh7th/cmp-cmdline'
		},
		config = function()
			local cmp = require('cmp')

			-- Helper function to check if there are non-whitespace characters before the cursor
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
			end

			cmp.setup({
				-- This is critical for not selecting the first entry.
				preselect = cmp.PreselectMode.None,

				-- 'menu': Show the completion menu.
				-- 'menuone': Show the menu even if there's only one item.
				-- 'noselect': IMPORTANT! This prevents auto-selecting the first item.
				-- 'noinsert': IMPORTANT! This prevents auto-inserting the common prefix or selected item.
				completion = {
					completeopt = 'menu,menuone,noselect,noinsert',
				},
				mapping = cmp.mapping.preset.insert({
					['<CR>'] = cmp.mapping.confirm({ select = true }),

					['<Tab>'] = function(fallback)
						if not cmp.select_next_item() then
							if vim.bo.buftype ~= 'prompt' and has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end
					end,

					['<S-Tab>'] = function(fallback)
						if not cmp.select_prev_item() then
							if vim.bo.buftype ~= 'prompt' and has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end
					end,

				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}),
			})
		end,
	},

  -- nvim-lspconfig: Configurations for Neovim's built-in LSP client
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Autocompletion integration with nvim-cmp
      -- If nvim-cmp is installed, ensure it's loaded before this.
      -- `cmp_nvim_lsp` provides default capabilities for nvim-cmp
      local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if cmp_nvim_lsp_ok then
          capabilities = cmp_nvim_lsp.default_capabilities()
      end

      -- The `on_attach` function is executed when an LSP client attaches to a buffer.
      -- This is where you set up LSP keymaps and basic buffer-local options.
      local on_attach = function(client, bufnr)
        -- Enable completion (omnifunc is used by some plugins/completion engines)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings for LSP functionalities
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set('n', '<space>k', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)

        -- Highlight references
        vim.api.nvim_create_autocmd('CursorHoldI', {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMovedI', {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- ===========================================
      -- Configure specific Language Servers
      -- IMPORTANT: You must install these servers manually on your system!
      -- E.g., for pyright: `npm install -g pyright`
      -- ===========================================

      -- Lua LSP (lua_ls) for Neovim config files
      -- lspconfig.lua_ls.setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      --   settings = {
      --     Lua = {
      --       runtime = {
      --         version = 'LuaJIT',
      --       },
      --       diagnostics = {
      --         globals = {'vim'},
      --       },
      --       workspace = {
      --         library = vim.api.nvim_get_runtime_file("", true),
      --         checkThirdParty = false,
      --       },
      --       telemetry = {
      --         enable = false,
      --       },
      --     },
      --   },
      -- })

      -- Python LSP (pyright)
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        -- You can add pyright specific settings here, e.g.:
        -- settings = {
        --   python = {
        --     analysis = {
        --       typeCheckingMode = "basic",
        --     },
        --   },
        -- },
      })

      -- TypeScript/JavaScript LSP (tsserver)
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- HTML LSP (html)
      lspconfig.html.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- CSS LSP (cssls)
      lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- JSON LSP (jsonls)
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Go LSP (gopls)
      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
            analyses = {
              nilness = true,
              unusedparams = true,
              shadow = true,
              unusedwrite = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
              setBoolParamNames = true,
            },
            linkTarget = "pkg.go.dev",
            templateExtensions = { ".tmpl", ".gohtml" },
          },
        },
        root_dir = require('lspconfig.util').root_pattern("go.mod", ".git"),
      })

      -- Diagnostics Configuration
      vim.diagnostic.config({
				virtual_text = {current_line = true},
        update_in_insert = true,
        severity_sort = true,
      })

      -- Set up signs for diagnostics (error, warn, info, hint)
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local name = "LspDiagnostics" .. type
        vim.fn.sign_define(name, { texthl = name, text = icon, numhl = "" })
      end

    end,
  },

  -- comment.nvim: Easy commenting
  {
    'numToStr/Comment.nvim',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring', -- For smarter commenting based on treesitter
    },
    config = function()
      require('Comment').setup({
        -- default mapping
        toggler = {
          line = '<leader>c',
        },
        -- LHS of operator-pending mappings
        opleader = {
          line = '<leader>c',
        },
        extra = {
          -- Add a space after the comment delimiters (// -> // )
          extra_commentstring = 'ts_context_commentstring',
        }
      })
    end
  },

  -- Telescope.nvim: Fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            ".git/",
          },
          mappings = {
            i = {
              ['<C-u>'] = require('telescope.actions').preview_scrolling_up,
              ['<C-d>'] = require('telescope.actions').preview_scrolling_down,
              ['<esc>'] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          -- You can add extensions here, e.g., 'fzf' if you have ripgrep and want fzf-native-search
          -- fzf = {
          --   fuzzy = true,
          --   override_generic_sorter = true,
          --   override_file_sorter = true,
          --   case_mode = 'smart_case',
          -- },
        },
      })
      -- Load extensions
      -- require('telescope').load_extension('fzf') -- if you enable fzf extension

      -- Keymaps for Telescope
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = "Find Files" })
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Find Buffers" })
      vim.keymap.set('n', '<leader>g', builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
      vim.keymap.set('n', '<leader>S', builtin.lsp_dynamic_workspace_symbols, { desc = "LSP Workspace Symbols" })
      vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = "LSP Diagnostics" })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = "LSP References" })
    end,
  },

  {
      'kylechui/nvim-surround',
      version = '*', -- Use version 2.x.x for Neovim 0.7+
      event = 'VeryLazy',
      config = function()
          require('nvim-surround').setup({
              keymaps = { normal = "s", visual = "s", delete = "ds", change = "cs" }
          })
      end
  },
}, {})

-- ===========================================
-- Language-Specific Settings (using Autocommands)
-- ===========================================

-- expandtab/noexpandtab -> whether entered tabs are turned into spaces
-- shiftwidth -> how many columns text is indented with << and >>
-- tabstop -> the number of spaces a tab is represented by
-- softtabstop -> used for mixing tabs and spaces if softtabstop < tabstop
--       and expandtab is not set

local all_twos = {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  expandtab = true,
}
local lang_settings = {
  javascript = all_twos,
  typescript = all_twos,
  html = all_twos,
  css = all_twos,
  json = all_twos,
  yaml = all_twos,
  lua = all_twos,
  python = {
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    expandtab = true,
  },
  go = {
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    expandtab = false,
  },
}

-- Create an autocmd group to manage our filetype settings
local ft_aug = vim.api.nvim_create_augroup('FileTypeSettings', { clear = true })

-- Iterate over the defined language settings and apply them
for filetype, settings in pairs(lang_settings) do
  vim.api.nvim_create_autocmd('FileType', {
    group = ft_aug,
    pattern = filetype,
    callback = function()
      -- Iterate through the settings for the current filetype and apply them
      for opt, value in pairs(settings) do
        vim.bo[opt] = value -- Use vim.bo for buffer-local options
      end
    end,
  })
end

-- ===========================================
-- General Neovim Options
-- ===========================================

vim.opt.nu = true                 -- Show line numbers
vim.opt.tabstop = 2               -- Number of spaces a tab counts for
vim.opt.softtabstop = 2           -- Number of spaces for a soft tab
vim.opt.shiftwidth = 2            -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.autoindent = true         -- Copy indent from current line when starting a new line
vim.opt.smartindent = true        -- Smart autoindenting
vim.opt.wrap = false              -- Don't wrap lines
vim.opt.swapfile = false          -- Don't use swapfile
vim.opt.backup = false            -- Don't create backup files
vim.opt.hlsearch = false          -- Do not highlight search results
vim.opt.incsearch = true          -- Incremental search
vim.opt.termguicolors = true      -- Enable true colors in the terminal
vim.opt.scrolloff = 999           -- Lines of context around the cursor
vim.opt.signcolumn = "yes"        -- Always show the sign column
vim.opt.isfname:append("@-@")     -- Allow hyphens in filenames for completion
vim.opt.updatetime = 300          -- Faster completion (ms to wait for swapfile ops)
vim.opt.timeoutlen = 500          -- Time to wait for mapped sequence to complete
vim.opt.autoread = true           -- Re-read changed files that have not had their buffer changed
vim.opt.clipboard = "unnamedplus" -- Yanks go to system clipboard, and pastes come from system clipboard
vim.opt.mouse = ""                -- Disable mouse mode

-- ===========================================
-- Basic Keymaps (Global)
-- ===========================================

vim.keymap.set("i", "{<CR>", "{\n}<C-c>O", { noremap = true, silent = true, desc = "{} with newline auto-pair" })
vim.keymap.set("i", "(<CR>", "(\n)<C-c>O", { noremap = true, silent = true, desc = "() with newline auto-pair" })
vim.keymap.set("i", "[<CR>", "[\n]<C-c>O", { noremap = true, silent = true, desc = "[] with newline auto-pair" })

vim.keymap.set("n", "ga", "<C-^>", { noremap = true, silent = true, desc = "Switch to previous buffer"})
vim.keymap.set("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo"})

-- ===========================================
-- Colorscheme
-- ===========================================

local colors = {
  light_gray = "#c6c6c6",
  dark_gray = "#858585",
  blue = "#007acc",
  turquoise = "#91ffff",
  pale_green = "#8fe289",
  dark_green = "#357a00",
  yellow = "#d7ba7d",
  pale_yellow = "#f9ffa1",
  pale_red = "#ff6868"
}

vim.cmd('colorscheme torte')

vim.api.nvim_set_hl(0, "Comment", { fg = colors.dark_green, italic = true })
vim.api.nvim_set_hl(0, "Type", { fg = colors.turquoise })
vim.api.nvim_set_hl(0, "Special", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "String", { fg = colors.pale_green })
vim.api.nvim_set_hl(0, "Character", { fg = colors.pale_green })
vim.api.nvim_set_hl(0, "Constant", { fg = colors.pale_orange })
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.pale_yellow })
vim.api.nvim_set_hl(0, "Statement", { fg = colors.pale_yellow })
vim.api.nvim_set_hl(0, "Conditional", { fg = colors.pale_yellow })
vim.api.nvim_set_hl(0, "Identifier", { fg = colors.light_gray })
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.dark_gray })

vim.api.nvim_set_hl(0, "diffRemoved", { fg = colors.pale_red })
vim.api.nvim_set_hl(0, "diffAdded", { fg = colors.pale_green })
vim.api.nvim_set_hl(0, "diffChanged", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "gitCommitSummary", { fg = colors.light_gray })
vim.api.nvim_set_hl(0, "gitCommitBranch", { fg = colors.dark_green })
vim.api.nvim_set_hl(0, "gitCommitHeader", { fg = colors.dark_green })
vim.api.nvim_set_hl(0, "diffFile", { fg = colors.dark_gray })
vim.api.nvim_set_hl(0, "diffIndexLine", { fg = colors.dark_gray })
vim.api.nvim_set_hl(0, "diffSubname", { fg = colors.dark_gray })
vim.api.nvim_set_hl(0, "diffNewFile", { fg = colors.dark_gray })
vim.api.nvim_set_hl(0, "diffOldFile", { fg = colors.dark_gray })
vim.api.nvim_set_hl(0, "diffLine", { fg = colors.turquoise })

vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.blue })
