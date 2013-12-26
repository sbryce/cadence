require 'class'
require 'Ball'
require 'Obstacle'
require 'specs'
vector = require 'hump.vector'
Timer = require 'hump.timer'

NoteGroup = newclass("NoteGroup")

function readAll(file)
  local f = io.open(file, "r")
  local content = f:read("*all")
  f:close()
  return content
end

function loadTable(data)
  local table = {}
  local f = assert(loadstring(data))
  setfenv(f, table)
  f()
  return table
end

-- We pass in beats per minute (bpm) instead of the more logical beats per second
-- because bpm is the standard measure of tempo in the music world
function NoteGroup:init(filename, startBeat, player)
  self.balls = {}
  self.obstacles = {}
  self.player = player
  local filepath = filepaths.musicPath .. filename .. ".mp3"
  self.audioSource = love.audio.newSource(filepath)
  local patternPath = filepaths.notePatternsPath .. filename .. ".lua"
  local pattern = loadTable(readAll(patternPath))
  self.pattern = pattern.notes
  self.bumps = pattern.bumps
  self.params = pattern.params
  --self.player.angle = pattern.params.shieldRad
  self.startBeat = startBeat
  self.spawnDistance = 600
  self.started = false
  self.angularOffset = math.random(0, 2 * 3.14)
end

function NoteGroup:spawnNote(noteSpecs)
  spawnPoint = vector(self.spawnDistance, 0):rotated(noteSpecs.angle + self.angularOffset)
  spawnPoint = spawnPoint + self.player.pos
  local radius = 5
  self.balls[#self.balls + 1] = Ball(self.player, spawnPoint, noteSpecs)
end

function NoteGroup:spawnBump(bumpSpecs)
  self.obstacles[#self.obstacles + 1] = Obstacle(self.spawnDistance + self.player.pos.x, bumpSpecs.width, bumpSpecs.speed, self.player)
end

function NoteGroup:update(dt)
  -- Update all the balls
  for i, ball in ipairs(self.balls) do
    ball:update(dt)
    if not ball.active then
      table.remove(self.balls, i)
    end
  end

  -- Update all the bumps
  for i, obstacle in ipairs(self.obstacles) do
    obstacle:update(dt)
  end

  -- Spawn balls
  for i, note in ipairs(self.pattern) do
    local offset = game.beatsPerSecond * ((self.spawnDistance - self.player.shieldRadius) / note.speed)
    local nb = note.beat + self.startBeat - 1
    if nb < game.globalBeat + offset and nb > game.prevGlobalBeat + offset then
      self:spawnNote(note)
      if i == 1 then
        -- Things to do when first note spawns
        self.player:setShieldWidth(self.params.shieldRad)
      end
    end
  end

  -- Spawn bumps
  for i, bump in ipairs(self.bumps) do
    local offset = game.beatsPerSecond * ((self.spawnDistance - 50) / bump.speed)
    local bb = bump.beat + self.startBeat - 1
    if bb < game.globalBeat + offset and bb > game.prevGlobalBeat + offset then
      self:spawnBump(bump)
    end
  end

  -- Things to do when first beat hits
  if game.globalBeat > self.startBeat and game.prevGlobalBeat < self.startBeat then
    self.audioSource:play()
    self.started = true
  end
end

function NoteGroup:draw()
  for i, obst in ipairs(self.obstacles) do
    obst:draw()
  end
  for i, ball in ipairs(self.balls) do
    ball:draw()
  end
end

