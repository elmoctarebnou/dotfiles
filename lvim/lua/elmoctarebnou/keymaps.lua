-- Normal --
-- Split mapping
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"

-- Resize with arrows
lvim.keys.normal_mode["<S-Up>"]= ":resize +2<CR>"
lvim.keys.normal_mode["<S-Down>"]= ":resize -2<CR>"
lvim.keys.normal_mode["<S-Left>"]=":vertical resize -2<CR>"
lvim.keys.normal_mode["<S-Right>"]=":vertical resize +2<CR>"

-- Navigate buffers use leader l and h
lvim.keys.normal_mode["<leader>l"] = ":bnext<CR>"
lvim.keys.normal_mode["<leader>h"] = ":bprevious<CR>"
-- Insert --
-- Press jj fast to enter
lvim.keys.insert_mode["jj"] = "<ESC>"

-- Visual --
-- Stay in indent mode
lvim.keys.visual_mode["<"]="<gv"
lvim.keys.visual_mode[">"]=">gv"

-- Keep registor when copy and pasting
lvim.keys.visual_mode["p"]='"_dP'

