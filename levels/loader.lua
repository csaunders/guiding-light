local sti = require("../lib/Simple-Tiled-Implementation")
local hc  = require("../lib/HardonCollider")
local walldistance = require("../walldistance")
local level = {}
level.__index = level

local function new(name)
  local self = setmetatable({}, level)
  self.map = sti.new("../maps/level1")
  self.map:setDrawRange(0, 0, 1000, 1000)
  self.wdc = walldistance.new(self.map.layers['Walls'].objects)

  for i, obj in ipairs(self.map.layers['poi'].objects) do
    if obj.type == 'end' then
      self.endPoint = obj
    elseif obj.type == 'start' then
      self.startPoint = obj
    end
  end

  self.collider = hc(10, self:oncollide, self:aftercollide)
  self.collider:addRectangle(self.endPoint.x, self.endPoint.y, self.endPoint.width, self.endPoint.height)

  self.cursor = level.collider:addRectangle(-1, -1, 10, 10)

  return self
end

function level:update(dt)
  self.cursor:moveTo(love.mouse.getPosition)
  self.collider:update(dt)
end

function level:draw()
  self.map:draw()
  self.wdc:draw()
  self:afterdraw()
end

function level:oncollide(dt, s1, s2, mtv_x, mtv_y)
end

function level:aftercollide(dt, s1, s2, mtv_x, mtv_y)
end

function level:afterdraw()
end

return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})
