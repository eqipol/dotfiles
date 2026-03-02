-- Переключение раскладки для Wayland/Hyprland
-- Запоминает раскладку при выходе из insert mode и восстанавливает при входе

local last_layout = 0  -- 0 = us, 1 = ru (по умолчанию us)

local function get_keyboard_name()
  local handle = io.popen("hyprctl devices -j 2>/dev/null")
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()

  local ok, json = pcall(vim.json.decode, result)
  if not ok then return nil end

  if json.keyboards then
    for _, kb in ipairs(json.keyboards) do
      if kb.main then
        return kb.name
      end
    end
    if #json.keyboards > 0 then
      return json.keyboards[1].name
    end
  end
  return nil
end

local function get_current_layout()
  local handle = io.popen("hyprctl devices -j 2>/dev/null")
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()

  local ok, json = pcall(vim.json.decode, result)
  if not ok then return nil end

  if json.keyboards then
    for _, kb in ipairs(json.keyboards) do
      if kb.main then
        return kb.active_layout_index
      end
    end
  end
  return nil
end

local function switch_layout(idx)
  local kb_name = get_keyboard_name()
  if not kb_name then return end

  local current = get_current_layout()
  if current == idx then return end

  vim.fn.system(string.format("hyprctl switchxkblayout '%s' %d", kb_name, idx))
end

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "i:*",  -- выход из insert mode: запоминаем раскладку и переключаем на us
  callback = function()
    local current = get_current_layout()
    if current then
      last_layout = current  -- запоминаем, на какой писали
    end
    switch_layout(0)  -- переключаем на us для normal mode
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:i",  -- вход в insert mode: восстанавливаем последнюю раскладку
  callback = function()
    switch_layout(last_layout)
  end,
})
