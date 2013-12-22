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
  table.insert(self.noteGroups, NoteGroup("fifths", 16, self.player))
  table.insert(self.noteGroups, NoteGroup("pianoArpMel1", 32, self.player))
  table.insert(self.noteGroups, NoteGroup("pianoArpMel2", 48, self.player))
  love.graphics.setBackgroundColor(207, 230, 230)
  local filepath = filepaths.musicPath .. "singleString" .. ".mp3"
  self.tracks = {}
  table.insert(self.tracks, love.audio.newSource(filepath))
  table.insert(self.tracks, love.audio.newSource(filepath))
  local audioData = love.sound.newSoundData(filepath)
  local sampleRate = audioData:getSampleRate()
  local beatsPerMinute = 120
  self.beatsPerSecond = beatsPerMinute / 60
  self.samplesPerBeat = sampleRate / self.beatsPerSecond
  love.audio.play(self.tracks[2])
  self.trackRepititions = 1
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
  local currentSample = self.tracks[self.trackRepititions % 2 + 1]:tell("samples")
  local currentBeat = currentSample / self.samplesPerBeat
  self.globalBeat = currentBeat + 16 * (self.trackRepititions - 1)
  if currentBeat > 16 then
    self.trackRepititions = self.trackRepititions + 1
    self.tracks[self.trackRepititions % 2 + 1]:play()
  end
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
