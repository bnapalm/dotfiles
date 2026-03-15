local M = {}

local function get_node_at_cursor(bufnr)
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
  if ok and node then
    return node
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]
  local parser = vim.treesitter.get_parser(bufnr, "nix")
  local tree = parser:parse()[1]

  return tree:root():named_descendant_for_range(row, col, row, col)
end

local function find_ancestor(node, wanted_type)
  while node do
    if node:type() == wanted_type then
      return node
    end
    node = node:parent()
  end
end

local function get_indent(bufnr, row, col)
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
  return line:sub(1, col)
end

local function indent_unit()
  local sw = vim.fn.shiftwidth()
  if sw == 0 then
    sw = vim.bo.tabstop
  end

  if vim.bo.expandtab then
    return string.rep(" ", sw)
  end

  return "\t"
end

local function split_lines(text)
  return vim.split(text, "\n", { plain = true })
end

local function get_binding_parts(binding, bufnr)
  local attrpath = binding:field("attrpath")[1] or binding:named_child(0)
  if not attrpath or attrpath:type() ~= "attrpath" then
    return nil, "No attrpath found on binding"
  end

  local rhs = nil
  for i = 0, binding:named_child_count() - 1 do
    local child = binding:named_child(i)
    if child and child:id() ~= attrpath:id() then
      rhs = child
      break
    end
  end

  if not rhs then
    return nil, "No value found on binding"
  end

  local parts = {}
  for i = 0, attrpath:named_child_count() - 1 do
    local child = attrpath:named_child(i)
    local child_type = child:type()
    if child_type ~= "identifier" and child_type ~= "string_expression" then
      return nil, string.format("Unsupported attrpath segment: %s", child_type)
    end

    local sr, sc, er, ec = child:range()
    if sr ~= er then
      return nil, "Multiline attrpath segments are not supported"
    end

    parts[#parts + 1] = {
      text = vim.treesitter.get_node_text(child, bufnr),
      start_row = sr,
      start_col = sc,
      end_col = ec,
    }
  end

  if #parts < 2 then
    return nil, "Attrpath is already flat"
  end

  local sr, sc, _, _ = binding:range()
  return {
    attrpath = attrpath,
    rhs = rhs,
    rhs_text = vim.treesitter.get_node_text(rhs, bufnr),
    parts = parts,
    indent = get_indent(bufnr, sr, sc),
    row = sr,
    col = sc,
  }
end

local function choose_split_index(parts, cursor)
  local row = cursor[1] - 1
  local col = cursor[2]

  if row < parts[1].start_row then
    return 1
  end

  if row > parts[#parts].start_row then
    return #parts - 1
  end

  local best_idx = 1
  local best_distance = math.huge

  for idx = 1, #parts - 1 do
    local boundary_col = parts[idx].end_col
    local distance = math.abs(col - boundary_col)
    if distance < best_distance or (distance == best_distance and idx < best_idx) then
      best_idx = idx
      best_distance = distance
    end
  end

  return best_idx
end

local function build_once(parts, split_idx, rhs_text, base_indent, step)
  local prefix = {}
  for i = 1, split_idx do
    prefix[#prefix + 1] = parts[i].text
  end

  local suffix = {}
  for i = split_idx + 1, #parts do
    suffix[#suffix + 1] = parts[i].text
  end

  local inner_indent = base_indent .. step
  return table.concat({
    table.concat(prefix, ".") .. " = {",
    inner_indent .. table.concat(suffix, ".") .. " = " .. rhs_text .. ";",
    base_indent .. "};",
  }, "\n")
end

local function build_all(parts, rhs_text, base_indent, step)
  local lines = {}

  for idx = 1, #parts - 1 do
    local indent = idx == 1 and "" or (base_indent .. string.rep(step, idx - 1))
    lines[#lines + 1] = indent .. parts[idx].text .. " = {"
  end

  local leaf_indent = base_indent .. string.rep(step, #parts - 1)
  lines[#lines + 1] = leaf_indent .. parts[#parts].text .. " = " .. rhs_text .. ";"

  for idx = #parts - 1, 1, -1 do
    local indent = base_indent .. string.rep(step, idx - 1)
    lines[#lines + 1] = indent .. "};"
  end

  return table.concat(lines, "\n")
end

local function replace_node_text(bufnr, node, replacement)
  local sr, sc, er, ec = node:range()
  vim.api.nvim_buf_set_text(bufnr, sr, sc, er, ec, split_lines(replacement))
end

local function explode(mode)
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "nix" then
    vim.notify("Nix attrpath explode only works in Nix buffers", vim.log.levels.WARN)
    return
  end

  local node = get_node_at_cursor(bufnr)
  local binding = node and find_ancestor(node, "binding")
  if not binding then
    vim.notify("Not on a Nix binding", vim.log.levels.WARN)
    return
  end

  local info, err = get_binding_parts(binding, bufnr)
  if not info then
    vim.notify(err, vim.log.levels.WARN)
    return
  end

  local replacement
  local step = indent_unit()
  if mode == "once" then
    local split_idx = choose_split_index(info.parts, vim.api.nvim_win_get_cursor(0))
    replacement = build_once(info.parts, split_idx, info.rhs_text, info.indent, step)
  else
    replacement = build_all(info.parts, info.rhs_text, info.indent, step)
  end

  replace_node_text(bufnr, binding, replacement)
  vim.api.nvim_win_set_cursor(0, { info.row + 1, info.col })
end

function M.explode_attrpath_once()
  explode("once")
end

function M.explode_attrpath_all()
  explode("all")
end

return M
