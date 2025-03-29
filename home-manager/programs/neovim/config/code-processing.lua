local lspc = require("lspconfig")
local treesitter = require("nvim-treesitter.configs")
local cmp = require("cmp")
local lspkind = require("lspkind")
require('nvim-autopairs').setup{}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

if not vim.g.nix_minimal_mode then
    lspc.nixd.setup{capabilities = capabilities}
    lspc.zls.setup {capabilities = capabilities}
    lspc.lua_ls.setup{
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
        },
      },
    }
    lspc.tinymist.setup {
        capabilities = capabilities,
        settings = {
            formatterMode = "typstyle",
            exportPdf = "onType",
            semanticTokens = "disable"
        }
    }
end
lspc.clangd.setup{capabilities = capabilities}
lspc.rust_analyzer.setup{capabilities = capabilities}
lspc.cmake.setup{capabilities = capabilities}
lspc.ruff.setup({capabilities = capabilities})
lspc.basedpyright.setup{capabilities = capabilities}
treesitter.setup({

	highlight = {
		enable = true,
		disable = { "lua" },
	},
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
})

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
	sources = {
        { name = "nvim_lsp" },
        { name = "cmp_tabnine" },
        { name = "treesitter" },
        { name = "buffer" },
        { name = "path" },
        { name = "vsnip" },
    },
    performance = {
        -- It is recommended to increase the timeout duration due to
        -- the typically slower response speed of LLMs compared to
        -- other completion sources. This is not needed when you only
        -- need manual completion.
        fetching_timeout = 2000,
    },
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	formatting = {
		format = lspkind.cmp_format({
			with_text = true,
			menu = {
				buffer = "[Buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
				treesitter = "[TS]",
				cmp_tabnine = "[TN]",
				vsnip = "[Snip]",
			},
		}),
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, {
			"i",
			"s",
		}),
	},
})

