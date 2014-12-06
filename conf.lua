function love.conf(t)
  t.window = t.window or t.screen

  t.title = "Echo"    -- The title of the window the game is in (string)
  t.author = "csaunders"    -- The author of the game (string)
  t.window.width = 1000     -- The window width (number)
  t.window.height = 1000     -- The window height (number)
  t.screen.fullscreen = false   -- Enable fullscreen (boolean)
  t.screen.vsync = false      -- Enable vertical sync (boolean)

  t.screen = t.screen or t.window
end
