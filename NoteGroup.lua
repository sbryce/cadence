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
function NoteGroup:init(filename, beatsPerMinute, player)
  self.balls = {}
  self.player = player
  local filepath = filepaths.musicPath .. filename .. ".mp3"
  self.audioSource = love.audio.newSource(filepath)
  local audioData = love.sound.newSoundData(filepath)
  local sampleRate = audioData:getSampleRate()
  self.beatsPerSecond = 60 / beatsPerMinute
  self.samplesPerBeat = sampleRate / self.beatsPerSecond
  local patternPath = filepaths.notePatternsPath .. filename .. ".lua"
  local pattern = loadTable(readAll(patternPath))
  self.pattern = pattern.notes
  self.spawnBeat = 1
  self.prevBeat = 0
  self.musicPlaying = false
  self.timedCurrentBeat = 0
  self.timedPreviousBeat = 0
end

function NoteGroup:spawnNote(noteSpecs)
  spawnPoint = vector(300, 0):rotated(noteSpecs.angle)
  spawnPoint = spawnPoint + self.player.pos
  local radius = 5
  self.balls[#self.balls + 1] = Ball(self.player, spawnPoint, 400, noteSpecs.beat, radius)
end

function NoteGroup:update(dt)
  self.timedCurrentBeat = self.timedCurrentBeat + dt * (1.0 / self.beatsPerSecond)

  -- Adjust ball velocities to sync with music thread
  --[[if self.musicPlaying then
    local currentSample = self.audioSource:tell("samples")
    local currentBeat = math.floor(currentSample / self.samplesPerBeat)
    local beatPercent = (currentSample % self.samplesPerBeat) / self.samplesPerBeat
    if currentBeat > self.prevBeat then
      for i, ball in ipairs(self.balls) do
        if not ball.willHit then
        ball.vel = (math.abs(ball.pos:dist(self.player.pos)) - self.player.radius + 2) / ((ball.beat - currentBeat - 1) * 0.5)
        end
      end
    end
    self.prevBeat = currentBeat
  end]]--

  -- Update all the balls
  for i, ball in ipairs(self.balls) do
    ball:update(dt)
    if not ball.active then
      table.remove(self.balls, i)
      if not self.musicPlaying then
        love.audio.play(self.audioSource)
        self.musicPlaying = true
      end
    end
  end

  -- Spawn balls
  for __, note in ipairs(self.pattern) do
    if note.beat < self.timedCurrentBeat and note.beat > self.timedPreviousBeat then
      self:spawnNote(note)
    end
  end

  self.timedPreviousBeat = self.timedCurrentBeat
end

function NoteGroup:draw()
  for i, ball in ipairs(self.balls) do
    ball:draw()
  end
end

