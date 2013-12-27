require 'class'
vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'Player'
require 'NoteGroup'
require 'Floor'
require 'Sky'
require 'Visualizer'

game = {}


function game:enter()
  self.player = Player(vector(400, 300))
  self.noteGroups = {}
  table.insert(self.noteGroups, NoteGroup("floor", 4, self.player))
  table.insert(self.noteGroups, NoteGroup("syncBass", 20, self.player))
  table.insert(self.noteGroups, NoteGroup("fastFifths", 36, self.player))
  table.insert(self.noteGroups, NoteGroup("stings", 52, self.player))
  love.graphics.setBackgroundColor(207, 230, 230)
  local filepath = filepaths.musicPath .. "empty" .. ".mp3"
  self.emptyTrack = love.audio.newSource(filepath)
  local audioData = love.sound.newSoundData(filepath)
  local sampleRate = audioData:getSampleRate()
  local beatsPerMinute = 185
  self.beatsPerSecond = beatsPerMinute / 60
  self.samplesPerBeat = sampleRate / self.beatsPerSecond
  love.audio.play(self.emptyTrack)
  self.globalBeat = 0
  self.prevGlobalBeat = 0
  self.floor = Floor(self.player)
  self.sky = Sky()
  self.effects = {}
  self.visualizers = {}
  table.insert(self.visualizers, Visualizer(550, 255, 50, 30))
  table.insert(self.visualizers, Visualizer(600, 255, 400, 60))
  --self.frontVis = Visualizer(780, 255, 2000, 100)
end

function game:update(dt)
  local currentSample = self.emptyTrack:tell("samples")
  local currentBeat = currentSample / self.samplesPerBeat
  self.globalBeat = currentBeat
  self.player:update(dt)
  self.floor:update(dt)
  for _, ng in ipairs(self.noteGroups) do
    ng:update(dt)
  end
  for _, fx in ipairs(self.effects) do
    fx:update(dt)
  end
  for _, v in ipairs(self.visualizers) do
    v:update(dt)
  end
  --self.frontVis:update(dt)
  Timer.update(dt)
  self.prevGlobalBeat = self.globalBeat
end

function game:draw()
  --self.sky:draw()
  for _, v in ipairs(self.visualizers) do
    self.sky:draw(100)
    v:draw()
  end
  self.floor:draw()
  self.player:draw()
  --self.frontVis:draw()
  for _, ng in ipairs(self.noteGroups) do
    ng:draw()
  end
  for _, fx in ipairs(self.effects) do
    fx:draw()
  end
end
