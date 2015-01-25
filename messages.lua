local font = love.graphics.newFont("fonts/SaniTrixieSans.ttf", 50)
font:setLineHeight(10)
love.graphics.setFont(font)

local widthPoint = love.graphics.getWidth() / 2
local defaultHeightPointRatio = 0.625

local function draw(color, messages, heightPointRatio)
  if not heightPointRatio then heightPointRatio = defaultHeightPointRatio end
  love.graphics.setColor(color)
  for i, sentence in ipairs(messages) do
    messageWidth = font:getWidth(sentence) / 2
    messageHeight = font:getHeight(sentence)
    love.graphics.print(sentence, widthPoint - messageWidth, love.graphics.getHeight()*heightPointRatio + (i - 1)*messageHeight)
  end
end

return {draw = draw}
