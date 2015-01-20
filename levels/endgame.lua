local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/death")
level.name = 'endgame'

SUCCESS = {
  "Your journey has come to an end"
}

THANK_YOU = {
  "Thank you for playing Guiding Light.","",
  "Created during Ludum Dare 31"
}

level.oldmouse = level.drawMouse

function level:drawMouse()
  self:oldmouse(love.graphics.getWidth() / 2, love.graphics.getHeight() / 4)
end

function level:beforeEnter(previous)
  exitSystem:stop()
  self.currentMessage = SUCCESS
  Timer.add(0.1, function() self:exciteParticles(MAX_SCALE/2) end)
  -- self:exciteParticles(MAX_SCALE/2)
  self:resetTween(function()
    Timer.tween(1, self.colors, {255, 255, 255, 0}, 'in-out-quad', function()
      self.currentMessage = THANK_YOU
      self:drainBuffer()
      self:resetTween()
    end)
  end)
end

function level:afterupdate(dt)
  Timer.update(dt)
  self:updateBuffers()
end

function level:afterdraw()
  Messages.draw(self.colors, self.currentMessage)
end

function level:exciteParticles(max)
  for i, sys in pairs(self.systems) do
    sys:setSpeed(0, max)
  end
end

function level:drainBuffer()
  self.endSpeed = {}
  self.systemSpeed = {}
  for i, sys in pairs(self.systems) do
    min, max = sys:getSpeed()
    self.systemSpeed[i] = max
    self.endSpeed[i] = 0
  end
  Timer.tween(10, self.systemSpeed, self.endSpeed, 'in-out-quad')
end

function level:updateBuffers()
  if not self.systemSpeed then return end

  for i, sys in pairs(self.systems) do
    newSpeed = self.systemSpeed[i]
    if newSpeed then sys:setSpeed(0, newSpeed) end
  end
end

function level:resetTween(callback)
  self.colors = {255, 255, 255, 0}
  Timer.tween(3, self.colors, {255, 255, 255, 255}, 'in-out-quad', callback)
end


return level
