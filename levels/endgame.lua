local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/death")
level.name = 'endgame'

level.collider:setCallbacks(makeOnCollideFn(level))

return level
