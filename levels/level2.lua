local loader = require("levels/loader")

local level = loader.new("maps/level2")
level.name = "level2"

level.collider:setCallbacks(makeOnCollideFn(level))

return level
