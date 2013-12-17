require 'class'
vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'Player'
require 'NoteGroup'

game = {}


function game:enter()
  player = Player(vector(400, 300))
  self.noteGroups = {}
  table.insert(self.noteGroups, NoteGroup("fifths", 16, player))
  table.insert(self.noteGroups, NoteGroup("pianoArpMel1", 32, player))
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
end

function game:update(dt)
  player:update(dt)
  local currentSample = self.tracks[self.trackRepititions % 2 + 1]:tell("samples")
  local currentBeat = currentSample / self.samplesPerBeat
  self.globalBeat = currentBeat + 16 * (self.trackRepititions - 1)
  if currentBeat > 16 then
    self.trackRepititions = self.trackRepititions + 1
    self.tracks[self.trackRepititions % 2 + 1]:play()
  end
  for _, ng in ipairs(self.noteGroups) do
    ng:update(dt)
  end
  Timer.update(dt)
  self.prevGlobalBeat = self.globalBeat
end

function game:draw()
  player:draw()
  for _, ng in ipairs(self.noteGroups) do
    ng:draw()
  end
end
