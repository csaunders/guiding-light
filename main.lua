local sti = require("lib/Simple-Tiled-Implementation")
local hc = require("lib/HardonCollider")
local walldistance = require("walldistance")
require("pshelp")

function love.load()
  width, height = love.graphics.getWidth(), love.graphics.getHeight()

  love.physics.setMeter(10)
  ready = false

  map = sti.new("maps/devmap")
  wdc = walldistance.new(map.layers['Walls'].objects)
  -- wdc:setDebug(true)

  particle = love.graphics.newImage('art/square.png')
  exit = getPS("systems/exit", particle)
  systems = {
    right = getPS("systems/wallCloseUp", particle),
    up = getPS("systems/wallCloseUp", particle),
    left = getPS("systems/wallCloseUp", particle),
    down = getPS("systems/wallCloseUp", particle),
  }

  systems.up:setDirection(4.71238898)
  systems.down:setDirection(1.570796327)
  systems.left:setDirection(3.141592653589793)
  systems.right:setDirection(0)

  objects = map.layers['poi'].objects
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
  require("lib/lovebird/lovebird").update()
  x, y = love.mouse.getPosition()
  if not ready then
    mouse:moveTo(love.mouse.getPosition())
    Collider:update(dt)
  else
    wdc:update(x, y, systems)
  end

  for i, sys in pairs(systems) do
    sys:update(dt)
  end
  exit:update(dt)
end

function love.draw()
  if not ready then informPlayer() end
  map:setDrawRange(0, 0, 1000, 1000)
  map:draw()
  wdc:draw()
  love.graphics.setBlendMode('additive')
  for i, sys in pairs(systems) do
    love.graphics.draw(sys, love.mouse.getPosition())
  end
  love.graphics.draw(exit, endPoint.x + (endPoint.width / 2), endPoint.y + (endPoint.height / 2))
end

function informPlayer()
  love.graphics.setColor(255, 0, 0)
  love.graphics.print("Before we can begin you must cooperate", width/2, height/2)
  love.graphics.print("Place your cursor over the green box", width/2, height/2 + 25)
end


function setupCollider()
  local onready = function()
    ready = true
  end
  Collider = hc(10, onready, function() end)

  Collider:addRectangle(startPoint.x, startPoint.y, startPoint.width, startPoint.height)
  return Collider:addRectangle(love.mouse.getX(), love.mouse.getY(), cursorImage:getWidth(), cursorImage:getHeight())
end
