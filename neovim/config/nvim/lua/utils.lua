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


return { packer_bootstrap = packer_bootstrap }

