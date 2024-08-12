-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
-- lvim.keys.normal_mode["<C-h>"] = "<C-w>h" -- To use: Ctrl + h
-- lvim.keys.normal_mode["<C-j>"] = "<C-w>j" -- To use: Ctrl + j
-- lvim.keys.normal_mode["<C-k>"] = "<C-w>k" -- To use: Ctrl + k
-- lvim.keys.normal_mode["<C-l>"] = "<C-w>l" -- To use: Ctrl + l
-- Split mapping
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"

-- Resize with arrows
lvim.keys.normal_mode["<S-Up>"]= ":resize +2<CR>"
lvim.keys.normal_mode["<S-Down>"]= ":resize -2<CR>"
lvim.keys.normal_mode["<S-Left>"]=":vertical resize -2<CR>"
lvim.keys.normal_mode["<S-Right>"]=":vertical resize +2<CR>"

-- Navigate buffers
lvim.keys.normal_mode["<S-l>"]=":bnext<CR>" -- To use: Shift + l
lvim.keys.normal_mode["<S-h>"]=":bprevious<CR>" -- To use: Shift + h


-- Insert --
-- Press jj fast to enter
lvim.keys.insert_mode["jj"] = "<ESC>"

-- Visual --
-- Stay in indent mode
lvim.keys.visual_mode["<"]="<gv"
lvim.keys.visual_mode[">"]=">gv"

-- Keep registor when copy and pasting
lvim.keys.visual_mode["p"]='"_dP'

