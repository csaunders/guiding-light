local breadcrumbs = {
  color = {255, 255, 255},
}
breadcrumbs.__index = breadcrumbs

local function new()
  return setmetatable({crumbs = {}}, breadcrumbs)
end

function breadcrumbs:addcrumb(x, y)
  key = x .. ":" .. y
  if not self.crumbs[key] then
    self.crumbs[key] = {x = x, y = y, count = 0}
  end
  crumb = self.crumbs[key]
  crumb.count = math.min((crumb.count + 5), 255)
end

function breadcrumbs:reset()
  self.crumbs = {}
end

function breadcrumbs:draw()
  love.graphics.setBlendMode("alpha")
  for i, crumb in pairs(self.crumbs) do
    love.graphics.setColor(255, 255, 255, crumb.count)
    love.graphics.rectangle("fill", crumb.x, crumb.y, 10, 10)
  end
  love.graphics.reset()
end

function breadcrumbs:update(dt)
  x, y = love.mouse.getPosition()
  self:addcrumb(x, y)
end

return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})
