require('plenary.reload').reload_module('telescope')

local tester = require('telescope.pickers._tests')

describe('builtin.find_files', function()
  it('should find the readme', function()
    tester.run_file('find_files__readme')
  end)

  it('should not display devicons when disabled', function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'README.md', {
        post_typed = {
          { "> README.md", GetPrompt },
          { "> README.md", GetLastResult },
        },
        post_close = {
          { 'README.md', GetFile },
          { 'README.md', GetFile },
        }
      }, {
        disable_devicons = true,
        sorter = require('telescope.sorters').get_fzy_sorter(),
      })
    ]]
  end)

  it('use devicons, if it has it when enabled', function()
    if not pcall(require, 'nvim-web-devicons') then
      return
    end

    tester.run_string [[
      tester.builtin_picker('find_files', 'README.md', {
        post_typed = {
          { "> README.md", GetPrompt },
          { ">  README.md", GetLastResult }
        },
        post_close = {
          { 'README.md', GetFile },
          { 'README.md', GetFile },
        }
      }, {
        disable_devicons = false,
        sorter = require('telescope.sorters').get_fzy_sorter(),
      })
    ]]
  end)

  it('should find the readme, using lowercase', function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'readme.md', {
        post_close = {
          { 'README.md', GetFile },
        }
      })
    ]]
  end)

  it('should find the pickers.lua, using lowercase', function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'pickers.lua', {
        post_close = {
          { 'lua/telescope/pickers.lua', GetFile },
        }
      })
    ]]
  end)

  it('should find the pickers.lua', function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'pickers.lua', {
        post_close = {
          { 'lua/telescope/pickers.lua', GetFile },
          { 'lua/telescope/pickers.lua', GetFile },
        }
      })
    ]]
  end)

  it('should be able to c-n the items', function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'fixtures/file<c-p>', {
        post_close = {
          { 'lua/tests/fixtures/file_2.txt', GetFile },
        }
      })
    ]]
  end)
end)
