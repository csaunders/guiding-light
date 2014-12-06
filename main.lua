local sti = require("lib/Simple-Tiled-Implementation")
local hc = require("lib/HardonCollider")
local timer = require("lib/hump/timer")

function love.load()
  width, height = love.graphics.getWidth(), love.graphics.getHeight()
  love.physics.setMeter(10)
  ready = false

  map = sti.new("maps/devmap")

  objects = map.layers['Object Layer 1'].objects
  for i, obj in ipairs(objects) do
    if obj.type == 'end' then
      endPoint = obj
    elseif obj.type == 'start' then
      startPoint = obj
    end
  end

  cursorImage = love.graphics.newImage("art/cursor.png")
  cursor = love.mouse.newCursor(cursorImage:getData(), cursorImage:getWidth()/2, cursorImage:getHeight()/2)
  love.mouse.setCursor(cursor)

  mouse = setupCollider()
end

function love.update(dt)
  if not ready then
    mouse:moveTo(love.mouse.getPosition())
    Collider:update(dt)
  end
end

function love.draw()
  if not ready then informPlayer() end
  map:setDrawRange(0, 0, 1000, 1000)
  map:draw()
end

function informPlayer()
  love.graphics.setColor(255, 0, 0)
  love.graphics.print("Before we can begin you must cooperate", width/2, height/2)
  love.graphics.print("Place your cursor over the green box", width/2, height/2 + 25)
end


function setupCollider()
  oncollide = function()
    ready = true
  end
  Collider = hc(10, function() ready = true end, function() end)

  Collider:addRectangle(startPoint.x, startPoint.y, startPoint.width, startPoint.height)
  return Collider:addRectangle(love.mouse.getX(), love.mouse.getY(), cursorImage:getWidth(), cursorImage:getHeight())
end
