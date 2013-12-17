require 'class'
require 'Ball'
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
  self.player = player
  local filepath = filepaths.musicPath .. filename .. ".mp3"
  self.audioSource = love.audio.newSource(filepath)
  local patternPath = filepaths.notePatternsPath .. filename .. ".lua"
  local pattern = loadTable(readAll(patternPath))
  self.pattern = pattern.notes
  self.startBeat = startBeat
  self.spawnDistance = 600
end

function NoteGroup:spawnNote(noteSpecs)
  spawnPoint = vector(self.spawnDistance, 0):rotated(noteSpecs.angle)
  spawnPoint = spawnPoint + self.player.pos
  local radius = 5
  self.balls[#self.balls + 1] = Ball(self.player, spawnPoint, noteSpecs)
end

function NoteGroup:update(dt)

  -- Update all the balls
  for i, ball in ipairs(self.balls) do
    ball:update(dt)
    if not ball.active then
      table.remove(self.balls, i)
    end
  end

  -- Spawn balls
  for __, note in ipairs(self.pattern) do
    local offset = 2 * ((self.spawnDistance - self.player.radius) / note.speed)
    local nb = note.beat + self.startBeat - 1
    if nb < game.globalBeat + offset and nb > game.prevGlobalBeat + offset then
      self:spawnNote(note)
    end
  end

  -- Play music
  if game.globalBeat > self.startBeat and game.prevGlobalBeat < self.startBeat then
    self.audioSource:play()
  end
end

function NoteGroup:draw()
  for i, ball in ipairs(self.balls) do
    ball:draw()
  end
end

