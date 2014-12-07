local sonar = {}
sonar.__index = sonar

local function new(tones)
  local sonar = setmetatable({tones = {}, up = nil, down = nil, left = nil, right = nil}, sonar)
  for i, tone in ipairs(tones) do
    for i, direction in ipairs(tone.directions) do
      local source = prepareTone(tone.source)
      table.insert(sonar.tones, source)
      sonar[direction] = source
    end
  end
  return sonar
end

function sonar:play()
  self:iterateTones(function(tone) tone:play() end)
end

function sonar:stop()
  self:iterateTones(function(tone) tone:stop() end)
end

function sonar:iterateTones(fn)
  for i, tone in ipairs(self.tones) do
    fn(tone)
  end
end

function prepareTone(name)
  local tone = love.audio.newSource(name, 'static')
  tone:setLooping(true)
  tone:setVolume(1.0)
  return tone
end

return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})
