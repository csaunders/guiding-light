local breadcrumbs = {
  color = {255, 255, 255},
}
breadcrumbs.__index = breadcrumbs

local DECAY = 0.65

local function new()
  return setmetatable({disabled = false, crumbs = {}}, breadcrumbs)
end

function breadcrumbs:addcrumb(x, y)
  key = x .. ":" .. y
  if not self.crumbs[key] then
    self.crumbs[key] = {x = x, y = y, visibility = 0, encountered = 0}
  end
  crumb = self.crumbs[key]
  crumb.encountered = crumb.encountered + 5
end

function breadcrumbs:reset()
  self.crumbs = {}
end

function breadcrumbs:disable()
  self.disabled = true
end

function breadcrumbs:enable()
  self.disabled = false
end

function breadcrumbs:updateVisibility()
  self:decayVisibilities()
  for i, crumb in pairs(self.crumbs) do
    crumb.visibility = math.min(crumb.visibility + crumb.encountered, 255)
    crumb.encountered = 0
  end
end

function breadcrumbs:draw()
  if self.disabled then return end

  love.graphics.setBlendMode("alpha")
  for i, crumb in pairs(self.crumbs) do
    love.graphics.setColor(255, 255, 255, crumb.visibility)
    love.graphics.rectangle("fill", crumb.x, crumb.y, 10, 10)
  end
  love.graphics.reset()
end

function breadcrumbs:update(dt)
  if self.disabled then return end

  x, y = love.mouse.getPosition()
  self:addcrumb(x, y)
end

function breadcrumbs:decayVisibilities()
  for i, crumb in pairs(self.crumbs) do
    crumb.visibility = crumb.visibility * DECAY
  end
end

return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})
