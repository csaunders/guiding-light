local level0 = require("levels/level0")
local level1 = require("levels/level1")
local level2 = require("levels/level2")
local level3 = require("levels/level3")
local level4 = require("levels/level4")
local level5 = require("levels/level5")
local endgame = require("levels/endgame")
death = require("levels/death")

levels = {
  level0, level1, level2, level3, level4, level5, endgame, death
}

levelTransitions = {
  level0 = level1,
  level1 = level2,
  level2 = level3,
  level3 = level4,
  level4 = level5,
  level5 = endgame
}

firstLevel = level1

function setParticleSystemOnLevels(systems)
  for i, lvl in pairs(levels) do
    lvl:setSystems(systems)
  end
end
