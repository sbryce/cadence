require 'class'
vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'Player'
require 'NoteGroup'
require 'Floor'
require 'Sky'
require 'Visualizer'

game = {}

function shuffle(t)
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end

function game:enter()
  self.player = Player(vector(400, 300))
  local groupNames = {"dnb", "fastFifths", "stings"}
  shuffle(groupNames)
  self.noteGroups = {}
  table.insert(self.noteGroups, NoteGroup(groupNames[1], 8, self.player))
  table.insert(self.noteGroups, NoteGroup(groupNames[2], 24, self.player))
  table.insert(self.noteGroups, NoteGroup(groupNames[3], 40, self.player))
  love.graphics.setBackgroundColor(207, 230, 230)
  local filepath = filepaths.musicPath .. "shortEmpty" .. ".mp3"
  self.tracks = {}
  table.insert(self.tracks, love.audio.newSource(filepath))
  table.insert(self.tracks, love.audio.newSource(filepath))
  --self.emptyTrack = love.audio.newSource(filepath)
  local audioData = love.sound.newSoundData(filepath)
  local sampleRate = audioData:getSampleRate()
  local beatsPerMinute = 187
  self.beatsPerSecond = beatsPerMinute / 60
  self.samplesPerBeat = sampleRate / self.beatsPerSecond
  self.globalBeat = 0
  self.prevGlobalBeat = 0
  self.floor = Floor(self.player)
  self.sky = Sky()
  self.effects = {}
  self.visualizers = {}
  table.insert(self.visualizers, Visualizer(550, 255, 50, 30))
  table.insert(self.visualizers, Visualizer(600, 255, 400, 60))
  --self.frontVis = Visualizer(780, 255, 2000, 100)
  self.currentTrack = 1
  self.tracks[self.currentTrack]:play()
end

function game:update(dt)
  local currentSample = self.tracks[(self.currentTrack - 1) % 2 + 1]:tell("samples")
  local currentBeat = currentSample / self.samplesPerBeat
  self.globalBeat = currentBeat + (self.currentTrack - 1) * 3
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

  local endBeat = (3 * self.currentTrack)
  if self.globalBeat > endBeat and self.prevGlobalBeat < endBeat then
    self.currentTrack = self.currentTrack + 1 
    self.tracks[(self.currentTrack - 1) % 2 + 1]:play()
  end

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
