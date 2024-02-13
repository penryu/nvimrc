--
-- commands.lua
--

local u = require('util')

-- Remove trailing carriage returns from misdetected DOS files
u.create_command('DeWinify', '%s/\r$//', { nargs = 0 })
