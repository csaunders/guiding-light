local loader = require("levels/loader")
local Timer  = require("lib/hump/timer")

local level = loader.new("maps/level0")
level.name = 'level0'
level.oldmouse = level.drawMouse

WELCOME = {
  "Welcome.",
  "Please take this light."
}

BEGIN = {
  "The light will show you the way and",
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
end

function level:enter(previous)
  exitSystem:stop()
  self.currentMessage = WELCOME
  self:resetTween()
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  self.hastorch = false
  self.changingLevels = false
end

function level:afterupdate(dt)
  Timer.update(dt)
end

function level:afterdraw()
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
