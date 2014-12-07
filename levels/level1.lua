local loader = require("levels/loader")

local level = loader.new("maps/level1")
level.name = 'level1'

level.collider:setCallbacks(makeOnCollideFn(level))

return level
