local sti = require("lib/Simple-Tiled-Implementation")
local hc  = require("lib/HardonCollider")
local walldistance = require("walldistance")
local Breadcrumb = require("breadcrumbs")
require("pshelp")

exitParticle = love.graphics.newImage("art/square.png")
exitSystem   = getPS("systems/exit", exitParticle)

local level = {}
level.__index = level

function makeOnCollideFn(context)
  local ctx = context
  return function(dt, s1, s2, mtv_x, mtv_y)
    if s1 == ctx.endRect or s2 == ctx.endRect then
      nextLevel()
    elseif s1 == ctx.cursor or s2 == ctx.cursor then
      print(s1.name .. " is colliding with " .. s2.name)
      showDeath()
      -- print("Colliding with something else")
    end
  end
end

function setMapVisiblity(map, visible)
  for i, layer in ipairs(map.layers) do
    layer.visible = visible
  end
end

local function new(name)
  local self = setmetatable({}, level)
  self.name = name
  self.map = sti.new(name)
  self.map:setDrawRange(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  setMapVisiblity(self.map, DEBUG)
  self.wdc = walldistance.new(self.map.layers['Walls'].objects)
  self.wdc:setDebug(DEBUG)

  for i, obj in ipairs(self.map.layers['poi'].objects) do
    if obj.type == 'end' then
      self.endPoint = obj
    elseif obj.type == 'start' then
      self.startPoint = obj
    end
  end

  self.collider = hc()
  self.collider.name = (name .. " Collider")
  self.rectangles = {}
  local deadzones = self.map.layers['DeadZones']
  if deadzones then
    for i, obj in ipairs(deadzones.objects) do
      rect = self.collider:addRectangle(obj.x, obj.y, obj.width, obj.height)
      rect.name = obj.name
      table.insert(self.rectangles, rect)
    end
  end

  self.endRect = self.collider:addRectangle(self.endPoint.x, self.endPoint.y, self.endPoint.width, self.endPoint.height)
  self.endRect.name = "endRect"

  self.cursor = self.collider:addRectangle(-1, -1, 10, 10)
  self.cursor.name = "cursor"

  self.breadcrumber = Breadcrumb.new()


  return self
end

function level:setSystems(systems)
  self.systems = systems
end

function level:drawMouse(x, y)
  for i, sys in pairs(systems) do
    if not sys:isStopped() then
      love.graphics.draw(sys, x, y)
    end
  end
end

function level:updateSystem(dt)
  for i, sys in pairs(systems) do
    sys:update(dt)
  end
end

function level:exitDrawPoint()
  return (self.endPoint.x + self.endPoint.width/2), (self.endPoint.y + self.endPoint.height/2)
end

function level:checkForDeath()
  if self.dying then return end
  if not self.stillOnPath then
    showDeath()
  end
end

function level:enter(previous)
  self:beforeEnter(previous)
  self.breadcrumber:updateVisibility()
end

function level:update(dt)
  if DEBUG then require("lib/lovebird/lovebird").update() end
  mx, my = love.mouse.getPosition()
  self.cursor:moveTo(love.mouse.getPosition())
  self.collider:update(dt)
  self.wdc:update(mx, my, self.systems)
  self.breadcrumber:update(dt)
  exitSystem:update(dt)
  self:updateSystem(dt)
  -- self:checkForDeath()
  self:afterupdate(dt)
end

function level:draw()
  self.map:draw()
  self.wdc:draw()
  love.graphics.setBlendMode("additive")
  love.graphics.draw(exitSystem, self:exitDrawPoint())
  self:drawMouse(love.mouse.getPosition())
  self:afterdraw()
  self.breadcrumber:draw()
  if DEBUG then self:drawRects() end
end

function level:drawRects()
  if not self.rectangles then return end
  for i, rect in pairs(self.rectangles) do
    love.graphics.setColor(self:colorFor(rect))
    love.graphics.polygon('fill', rect._polygon:unpack())
    love.graphics.setColor(255, 255, 255)
    x,y = rect:bbox()
    love.graphics.print(rect.name, x, y)
    love.graphics.reset()
  end
end

function level:colorFor(rect)
  color = {255, 255, 255}
  if rect.name == 'Upper' then
    color[1] = 0
  elseif rect.name == 'Lower' then
    color[2] = 0
  elseif rect.name == 'Left' then
    color[2] = 0
    color[3] = 0
  elseif rect.name == 'Right' then
    color[1] = 128
  elseif rect.name == 'Middle' then
    color[1] = 0
    color[3] = 0
  else
    color = {0, 0, 255}
  end
  return color
end

function level:beforeEnter(previous)
end

function level:afterupdate(dt)
end

function level:afterdraw()
end

function level:keyreleased(key, code)
  if key == 'd' then
    DEBUG = not DEBUG
    self.wdc:setDebug(DEBUG)
    setMapVisiblity(self.map, DEBUG)
  elseif key == 'm' then
    if mainTheme:isStopped() then
      mainTheme:play()
    elseif mainTheme:isPaused() then
      mainTheme:resume()
    else
      mainTheme:pause()
    end
  end
end

return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})
