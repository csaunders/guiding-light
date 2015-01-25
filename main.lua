local sti = require("lib/Simple-Tiled-Implementation")
local hc = require("lib/HardonCollider")
local walldistance = require("walldistance")
Messages  = require("messages")
Gamestate = require("lib/hump/gamestate")
require("pshelp")

RELEASE = false
DEBUG = false
MAX_SCALE = 750

-- if DEBUG then require("mobdebug").start() end

require("levels")

function nextLevel()
  current = Gamestate.current()
  nextLvl = levelTransitions[current.name]
  if nextLvl then Gamestate.switch(nextLvl) end
end

function showDeath()
  Gamestate.switch(death)
end

function love.load()
  width, height = love.graphics.getWidth(), love.graphics.getHeight()
  setupParticleSystems()
  setParticleSystemOnLevels(systems)
  setupMusic()

  Gamestate.registerEvents()
  Gamestate.switch(firstLevel)
end

function setupParticleSystems()
  particle = love.graphics.newImage('art/square.png')
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
end

function setupMusic()
  mainTheme = love.audio.newSource("music/water_lily.mp3", "stream")
  mainTheme:setLooping(true)
  if not DEBUG then mainTheme:play() end
end
