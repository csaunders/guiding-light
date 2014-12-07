local loader = require("levels/loader")

local level = loader.new("maps/level4")
level.name = "level4"

level.collider:setCallbacks(makeOnCollideFn(level))

return level
