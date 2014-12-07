local sti = require("lib/Simple-Tiled-Implementation")
local hc  = require("lib/HardonCollider")
local walldistance = require("walldistance")
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
    end
  end
end

local function aftercollide(dt, s1, s2, mtv_x, mtv_y)
end

function setMapVisiblity(map, visible)
  for i, layer in ipairs(map.layers) do
    layer.visible = visible
  end
end

local function new(name)
  local self = setmetatable({}, level)
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

  self.collider = hc(10)
  self.endRect = self.collider:addRectangle(self.endPoint.x, self.endPoint.y, self.endPoint.width, self.endPoint.height)
  self.endRect.name = "endRect"

  self.cursor = self.collider:addRectangle(-1, -1, 10, 10)
  self.cursor.name = "cursor"

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
  for i, sys in pairs(systems) do
    min, max = sys:getSpeed()
    if max == MAX_SCALE then
      showDeath()
    end
  end
end

function level:update(dt)
  if DEBUG then require("lib/lovebird/lovebird").update() end
  mx, my = love.mouse.getPosition()
  self.cursor:moveTo(love.mouse.getPosition())
  self.collider:update(dt)
  self.wdc:update(mx, my, self.systems)
  exitSystem:update(dt)
  self:updateSystem(dt)
  self:checkForDeath()
  self:afterupdate(dt)
end

function level:draw()
  self.map:draw()
  self.wdc:draw()
  love.graphics.setBlendMode("additive")
  love.graphics.draw(exitSystem, self:exitDrawPoint())
  self:drawMouse(love.mouse.getPosition())
  self:afterdraw()
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
  end
end

return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})
