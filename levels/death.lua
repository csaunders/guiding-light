local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/death")
level.name = 'death'

FAILURE_QUOTE = {
  "Our greatest glory is not in never falling,",
  "but in rising every time we fall."
}

local function collide()
  previous = level.previous
  level.previous = nil
  Gamestate.switch(previous)
end

function level:enter(previous)
  if previous == self then return end
  self.color = {255, 255, 255, 0}
  Timer.tween(2, self.color, {255, 255, 255, 255}, 'in-out-quad', function()
    Timer.tween(1, self.color, {255, 255, 255, 0}, 'in-out-quad')
  end)

  self.collider:clear()

  self.previous = previous
  exit = previous.startPoint
  self.endPoint = previous.startPoint
  self.endRect = self.collider:addRectangle(exit.x, exit.y, exit.width, exit.height)
  self.collider:addShape(self.cursor)
  self.collider:setCallbacks(collide)
  self:calmParticles()
end

function level:calmParticles()
  for i, sys in pairs(self.systems) do
    sys:setSpeed(0, 25)
  end
end

function level:afterupdate(dt)
  Timer.update(dt)
end

function level:afterdraw()
  Messages.draw(self.color, FAILURE_QUOTE)
end

return level
