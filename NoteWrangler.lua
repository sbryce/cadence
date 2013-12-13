require 'class'
require 'ball'
require 'specs'
vector = require 'hump.vector'
Timer = require 'hump.timer'

NoteWrangler = newclass("NoteWrangler")

function NoteWrangler:init(player)
  self.balls = {}
  self.player = player
  local musicPath = specs.musicPath
  self.fifths = love.audio.newSource(musicPath .. "fifths.mp3")
  self.string = love.audio.newSource(musicPath .. "singleString.mp3")
  self.piano = love.audio.newSource(musicPath .. "pianoArpMel1.mp3")
  local fifthsData = love.sound.newSoundData(musicPath .. "fifths.mp3")
  local sampleRate = fifthsData:getSampleRate()
  self.samplesPerBeat = sampleRate / 2
  --love.audio.play(self.fifths)
  self.angle = 0
  self.spawnBeat = 1
  self:spawnNote()
  self.prevBeat = 0
  self.musicPlaying = false
  Timer.addPeriodic(0.25, function() self:spawnNote() end )
end

function NoteWrangler:spawnNote()
  self.angle = (self.angle + 0.3) % 1
  spawnPoint = vector(300, 0):rotated(self.angle)
  spawnPoint = spawnPoint + self.player.pos
  local radius = 5
  if (self.spawnBeat * 2) % 2 == 0 then
    radius = 10
  end
  self.balls[#self.balls + 1] = Ball(self.player, spawnPoint, 400, self.spawnBeat, radius)
  self.spawnBeat = self.spawnBeat + 0.5
end

function NoteWrangler:update(dt)
  if self.musicPlaying then
    local currentSample = self.fifths:tell("samples")
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
  end
  for i, ball in ipairs(self.balls) do
    ball:update(dt)
    if not ball.active then
      table.remove(self.balls, i)
      if not self.musicPlaying then
        love.audio.play(self.fifths)
        love.audio.play(self.string)
        love.audio.play(self.piano)
        self.musicPlaying = true
      end
    end
  end
end

function NoteWrangler:draw()
  for i, ball in ipairs(self.balls) do
    ball:draw()
  end
end

