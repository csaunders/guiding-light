local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/level1")
level.name = 'level1'

MESSAGES = {
  "The light can see things that you cannot.",
  "Allow it to be your guide."
}

function level:init()
  self.colors = {255, 255, 255, 0}
  Timer.tween(3, self.colors, {255, 255, 255, 255}, 'in-out-quad', function()
    Timer.add(2, function()
      Timer.tween(1, self.colors, {255, 255, 255, 0}, 'in-out-quad')
    end)
  end)
end

function level:afterdraw()
  Messages.draw(self.colors, MESSAGES)
end

level.collider:setCallbacks(makeOnCollideFn(level))

return level
