local loader = require("levels/loader")

local level = loader.new("maps/level0")
level.name = 'level0'
level.oldmouse = level.drawMouse

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

function level:collide(dt, s1, s2, mtv_x, mtv_y)
end

function level:enter(previous)
  love.mouse.setCursor(love.mouse.getSystemCursor('crosshair'))
  self.hastorch = false
end

function level:afterdraw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Welcome.", love.graphics.getWidth() / 4, love.graphics.getHeight() / 4)
  love.graphics.print("Please take this light. It shall guide you on your way", love.graphics.getWidth() / 4, (love.graphics.getHeight() / 4) + 10)
end

local function collide(dt, s1, s2, mtv_x, mtv_y)
  if s1 == level.torchRect or s2 == level.torchRect then
    level.hastorch = true
    cursorImage = love.graphics.newImage("art/cursor.png")
    cursor = love.mouse.newCursor(cursorImage:getData(), cursorImage:getWidth()/2, cursorImage:getHeight()/2)
    love.mouse.setCursor(cursor)
  elseif level.hastorch then
    nextLevel()
  end
end
level.collider:setCallbacks(collide)

return level
