local vector = require("lib/hump/vector")
local walldistance = {}
walldistance.__index = walldistance

local function new(lines)
  return setmetatable({rays = {}, lines = lines or {}, debug = false}, walldistance)
end

local function setSpeed(system, scale, seen)
  local min, max = system:getSpeed()
  if (seen and max < scale) or not seen then
    system:setSpeed(scale)
  end
end

function walldistance:setDebug(debug)
  self.debug = debug
end

function walldistance:draw()
  if not self.debug then return end
  for i, ray in ipairs(self.rays) do
    love.graphics.line(ray.sx, ray.sy, ray.ex, ray.ey)
  end
end

function walldistance:update(x, y, systems)
  seen = {} -- hack to get the right rays used
  self.rays = projectRays(x, y, self.lines)
  for i, ray in ipairs(self.rays) do
    if self:up(ray) then
      setSpeed(systems.up, ray.scale, seen.up)
      seen.up = true
    elseif self:down(ray) then
      setSpeed(systems.down, ray.scale, seen.down)
      seen.down = true
    elseif self:left(ray) then
      setSpeed(systems.left, ray.scale, seen.left)
      seen.left = true
    elseif self:right(ray) then
      setSpeed(systems.right, ray.scale, seen.right)
      seen.right = true
    end
  end
end

function walldistance:up(ray)
  return ray.sx - ray.ex == 0 and (ray.sy - ray.ey) < 0
end

function walldistance:down(ray)
  return ray.sx - ray.ex == 0 and (ray.sy - ray.ey) > 0
end

function walldistance:left(ray)
  return ray.sy - ray.ey == 0 and (ray.sx - ray.ex) < 0
end

function walldistance:right(ray)
  return ray.sy - ray.ey == 0 and (ray.sx - ray.ex) > 0
end

function projectRays(x, y, lines)
  local rays = {}
  for i, line in ipairs(lines) do
    result = projectOnto(x, y, line)
    if result then table.insert(rays, result) end
  end
  return rays
end

function projectOnto(x, y, line)
  cursor = vector.new(x - line.x, y - line.y)
  -- All my polylines consist of 2 points. The start and the end, just grab the end
  lineEnd = line.polyline[2]
  props = line.properties
  edge = vector.new(lineEnd.x - line.x, lineEnd.y - line.y)
  projection = cursor:projectOn(edge)
  if projection:len() > edge:len() or projection.x < 0 or projection.y < 0 then
    return nil
  else
    return {
      sx = projection.x + line.x, sy = projection.y + line.y, ex = x, ey = y,
      scale = MAX_SCALE / math.abs(projection:dist(cursor)),
      r = tonumber(props["r"]), g = tonumber(props["g"]), b = tonumber(props["b"])
    }
  end
end

return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})
