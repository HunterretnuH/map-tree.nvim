local M = {}

-- The tree table
M.map_tree = {}

-- Helper: split lhs string into elements treating <...> as single element
local function split_keys(lhs)
    local elements = {}
    local i = 1
    while i <= #lhs do
        local c = lhs:sub(i,i)
        if c == "<" then
            local j = lhs:find(">", i)
            if j then
                table.insert(elements, lhs:sub(i, j))
                i = j + 1
            else
                -- no closing >, treat as normal char
                table.insert(elements, c)
                i = i + 1
            end
        else
            table.insert(elements, c)
            i = i + 1
        end
    end
    return elements
end

-- Print tree recursively into a buffer with aligned descriptions and sorted keys
local function print_tree(tree, buf, indent_start, indent_increment, distance)
    indent_start = indent_start or ""
    indent_increment = indent_increment or "    "
    distance = distance or 12

    -- Collect keys and sort them
    local keys = {}
    for k in pairs(tree) do
        if k ~= "desc" then
            table.insert(keys, k)
        end
    end
    table.sort(keys)

    -- Print entries
    for _, k in ipairs(keys) do
        local v = tree[k]
        local line = indent_start .. k
        if v.desc then
            local spaces_count = distance - #k
            if spaces_count < 1 then spaces_count = 1 end
            local spaces = string.rep(" ", spaces_count)
            line = line .. spaces .. v.desc
        end
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
        print_tree(v, buf, indent_start .. indent_increment, indent_increment, distance)
    end
end

local function print_tree_to_buf(tree, buf, indent, distance)
    indent = indent or "    "
    distance = distance or 12

    -- Print header
    local header = "MAPPING";
    local spaces_count = distance - #header
    header = header .. string.rep(" ", spaces_count) .. "DESCRIPTION"
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { header })

    -- Print tree
    print_tree(tree, buf, "", indent, distance)
end

-- Insert a key sequence into the tree
function M.register(lhs, desc)
    if desc == nil or desc == "" then
        return
    end

    local keys = split_keys(lhs)
    local node = M.map_tree

    for i, key in ipairs(keys) do
        if not node[key] then
            node[key] = {}
        end
        if i == #keys then
            node[key].desc = desc
        end
        node = node[key]
    end
end


-- Open new buffer and print tree
function M.open()
    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true) -- [listed = false, scratch = true]

    -- Optionally set some buffer options
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "lua")

    -- Fill buffer with tree
    print_tree_to_buf(M.map_tree, buf)

    -- Open a new window and set buffer
    --vim.api.nvim_command("vsplit")  -- or "vsplit" for vertical
    vim.api.nvim_win_set_buf(0, buf)
end

function M.setup(opts)
    opts = opts or {}
    vim.api.nvim_create_user_command("MapTreeOpen", function() M.open() end, { desc = "Show keybindings tree" })
end

return M
