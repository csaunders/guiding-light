local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/death")
level.name = 'death'

FAILURE_QUOTES = {
  {"Our greatest glory is not in never falling,",
  "but in rising every time we fall."},
  {"Everything you want is on the other side of fear."},
  {"Giving up is the only sure way to fail."},
  {"Success is stumbling from failure to failure",
  "with no loss of enthusiasm."},
  {"Satisfaction lies in the effort,",
  "not in the attainment.","",
   "Full effort is full victory."}
}

ACTIVE_QUOTE = nil

local function chooseQuote()
  index = math.random(#FAILURE_QUOTES)
  ACTIVE_QUOTE = FAILURE_QUOTES[5]
end

local function collide()
  previous = level.previous
  level.previous = nil
  Gamestate.switch(previous)
end

function level:init()
  self.breadcrumber:disable()
end

function level:beforeEnter(previous)
  if previous == self then return end
  self.color = {255, 255, 255, 0}
  Timer.tween(2, self.color, {255, 255, 255, 255}, 'in-out-quad', function()
    Timer.tween(1, self.color, {255, 255, 255, 0}, 'in-out-quad')
  end)

  chooseQuote()

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
  Messages.draw(self.color, ACTIVE_QUOTE)
end

return level
