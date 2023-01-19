local bootstrap_cached = nil

-- Return true if install packer, false if packer exists
-- Return value is cached so value not change while app is running
local function packer_bootstrap()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if bootstrap_cached == nil then
    if fn.empty(fn.glob(install_path)) > 0 then
      vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd.packadd('packer.nvim')

      bootstrap_cached = true
    else
      bootstrap_cached = false
    end
  end

  return bootstrap_cached
end


function get_bufs_loaded()
  local bufs_loaded = {}

  for i, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      table.insert(bufs_loaded, buf)
    end
  end

  return bufs_loaded
end


function open_term()
  local term_buf = nil

  for i, buf in ipairs(get_bufs_loaded()) do
    if string.find(vim.api.nvim_buf_get_name(buf), "term://") ~= nil then
      term_buf = buf
      break
    end
  end

  if term_buf ~= nil then
    -- attach to existing terminal
    vim.api.nvim_win_set_buf(0, term_buf)
  else
    -- if not exist, open new terminal
    vim.cmd.terminal()
  end

  -- Disable line number and enter insert mode
  vim.cmd.startinsert()
  vim.opt_local.number = false
end


return { packer_bootstrap = packer_bootstrap, open_term = open_term }

