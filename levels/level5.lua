local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/level5")
level.name = 'level5'

level.collider:setCallbacks(makeOnCollideFn(level))

return level
