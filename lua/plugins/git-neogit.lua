-- Get the primary branch from the remote
local function get_primary_branch()
  local handle = io.popen("git remote show origin | grep 'HEAD branch' | awk '{print $NF}'")

  if not handle then
    vim.notify("Error detecting primary branch: " .. (err or "Unknown error"), vim.log.levels.ERROR)
    return nil
  end

  local branch = handle:read("*a"):gsub("%s+", "")
  handle:close()

  return branch or nil
end


return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local neogit = require('neogit')
    vim.keymap.set('n', '<leader>gs', function() neogit.open({ kind = 'split' }) end, { desc = '[G]it [s]how' })
    vim.keymap.set('n', '<leader>gdo', function() vim.cmd('DiffviewOpen') end, { desc = '[G]it [d]iff [o]pen' })
    vim.keymap.set('n', '<leader>gdc', function() vim.cmd('DiffviewClose') end, { desc = '[G]it [d]iff [c]lose' })
    vim.keymap.set('n', '<leader>gdp', function()
      local primary_branch = get_primary_branch()
      if primary_branch then
        vim.cmd('DiffviewOpen ' .. primary_branch .. '...HEAD')
      end
    end, { desc = '[G]it [d]iff [p]rimary' })
    neogit.setup({
      graph_style = 'unicode',
      integrations = {
        diffview = true,
        telescope = true,
      },

    })
  end
}
