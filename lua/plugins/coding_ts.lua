local option = require('init.options')
local keymap = require('init.keymaps')

return {
	-- language parser
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {
			auto_install = false,
			ensure_installed = option.plugins.ts_parsers,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		},
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end,
		dependencies = {
			-- auto load
			'nvim-treesitter/nvim-treesitter-refactor',
			'HiPhish/rainbow-delimiters.nvim',
		},
	},

	-- ts refactor module
	{
		'nvim-treesitter/nvim-treesitter-refactor',
		lazy = true,
		config = function()
			require('nvim-treesitter.configs').setup({
				refactor = {
					highlight_definitions = { enable = true },
					highlight_current_scope = { enable = false },
					navigation = {
						enable = true,
						keymaps = keymap.ts_refactor.navigate,
					},
					smart_rename = {
						enable = true,
						keymaps = keymap.ts_refactor.rename,
					},
				},
			})
		end,
	},

	-- rainbow parentheses with ts
	{
		'HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		config = function()
			local rainbow = require('rainbow-delimiters')
			require('rainbow-delimiters.setup')({
				strategy = {
					[''] = rainbow.strategy['global'],
					vim = rainbow.strategy['local'],
				},
				query = {
					[''] = 'rainbow-delimiters',
					lua = 'rainbow-blocks',
				},
				highlight = {
					'RainbowDelimiterRed',
					'RainbowDelimiterYellow',
					'RainbowDelimiterBlue',
					'RainbowDelimiterOrange',
					'RainbowDelimiterGreen',
					'RainbowDelimiterViolet',
					'RainbowDelimiterCyan',
				},
			})
		end,
	},

	-- tabout
	{
		'abecodes/tabout.nvim',
		config = function()
		require('tabout').setup {
			tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
			backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
			act_as_tab = true, -- shift content if tab out is not possible
			act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
			-- default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
			-- default_shift_tab = '<C-d>', -- reverse shift default action,
			enable_backwards = true, -- well ...
			completion = true, -- if the tabkey is used in a completion pum
			tabouts = {
				{open = "'", close = "'"},
				{open = '"', close = '"'},
				{open = '`', close = '`'},
				{open = '(', close = ')'},
				{open = '[', close = ']'},
				{open = '{', close = '}'}
			},
			ignore_beginning = false, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
			exclude = {} -- tabout will ignore these filetypes
		}
		end,
		wants = {'nvim-treesitter'}, -- or require if not used so far
		after = {'nvim-cmp'} -- if a completion plugin is using tabs load it before
	}
}
