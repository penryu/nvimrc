--
-- commands.lua
--

local u = require 'util'

-- :Sh opens term in new window
u.create_command('Sh', 'new +terminal', { nargs = '*' })

-- Remove trailing carriage returns from misdetected DOS files
u.create_command('DeWinify', '%s/\r$//', { nargs = 0 })
