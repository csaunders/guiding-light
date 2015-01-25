local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/level0")
level.name = 'level0'
level.oldmouse = level.drawMouse

local torchImage = love.graphics.newImage("art/square.png")
startingTorchSystem = getPS("systems/startingTorch", torchImage)
defaultStartingTorchEmissionRate = startingTorchSystem:getEmissionRate()

WELCOME = {
  "Welcome.",
  "Please take this light."
}

BEGIN = {
  "This will show you the way and",
  "protect you from the dangers ahead.",
}

function level:drawMouse(x, y)
  if not self.hastorch then
    x = love.graphics.getWidth() / 2
    y = love.graphics.getHeight() / 2
  end
  self:oldmouse(x, y)
end

function level:init()
  self.torchRect = self.collider:addRectangle(self.startPoint.x, self.startPoint.y, self.startPoint.width, self.startPoint.height)
  self.torchRect.name = "torch"
  self.collider.setCallbacks(self.oncollide)
  self.breadcrumber:disable()
end

function level:beforeEnter(previous)
  exitSystem:stop()
  self:stopSystems()
  startingTorchSystem:setEmissionRate(defaultStartingTorchEmissionRate)
  self.currentMessage = WELCOME
  self:resetTween()
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  self.hastorch = false
  self.changingLevels = false
end

function level:afterupdate(dt)
  startingTorchSystem:update(dt)
  Timer.update(dt)
end

function level:afterdraw()
  print(startingTorchSystem)
  print(self.startPoint.x .. "," .. self.startPoint.y)
  love.graphics.draw(startingTorchSystem, self.startPoint.x, self.startPoint.y)
  Messages.draw(self.colors, self.currentMessage)
end

function level:resetTween(callback)
  self.colors = {255, 255, 255, 0}
  Timer.tween(3, self.colors, {255, 255, 255, 255}, 'in-out-quad', callback)
end

function level:readyForNextLevel()
  return self.hastorch and not self.changingLevels
end

local function collide(dt, s1, s2, mtv_x, mtv_y)
  if s1 == level.torchRect or s2 == level.torchRect then
    if level.hastorch then return end
    startingTorchSystem:setEmissionRate(0)
    level:startSystems()
    level.hastorch = true
    cursorImage = love.graphics.newImage("art/cursor.png")
    cursor = love.mouse.newCursor(cursorImage:getData(), cursorImage:getWidth()/2, cursorImage:getHeight()/2)
    love.mouse.setCursor(cursor)
    level:resetTween()
    level.currentMessage = BEGIN
    exitSystem:start()
  elseif level:readyForNextLevel() then
    level.changingLevels = true
    nextLevel()
  end
end
level.collider:setCallbacks(collide)

return level
