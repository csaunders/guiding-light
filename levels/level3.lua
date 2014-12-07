local loader = require("levels/loader")

local level = loader.new("maps/level3")
level.name = "level3"

level.collider:setCallbacks(makeOnCollideFn(level))

return level
