local level0 = require("levels/level0")
local level1 = require("levels/level1")

levels = {
  level0 = level0,
  level1 = level1,
  -- level2 = require("levels/level2")
}

levelTransitions = {
  level0 = level1
}

firstLevel = level0

-- death = require("death")

function setParticleSystemOnLevels(systems)
  for i, lvl in pairs(levels) do
    lvl:setSystems(systems)
  end
end
