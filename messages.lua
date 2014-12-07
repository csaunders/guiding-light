local font = love.graphics.newFont("fonts/SaniTrixieSans.ttf", 50)
font:setLineHeight(10)
love.graphics.setFont(font)

local widthPoint = love.graphics.getWidth() / 2
local heightPoint = (5 * love.graphics.getHeight()) / 8
local maxMessageWidth = (love.graphics.getWidth() * 3) / 4

local function draw(color, messages)
  love.graphics.setColor(color)
  for i, sentence in ipairs(messages) do
    messageWidth = font:getWidth(sentence) / 2
    messageHeight = font:getHeight(sentence)
    love.graphics.print(sentence, widthPoint - messageWidth, heightPoint + (i - 1)*messageHeight)
  end
end

return {draw = draw}
