require 'class'
require 'Player'
require 'NoteGroup'

BuildSection = newclass("BuildSection")

function BuildSection:init(groupNames, startBeat, player)
  self.groupNames = groupNames
  self.startBeat = startBeat
  self.player = player
  self.noteGroups = {}
  local volume = 1 / table.getn(groupNames)
  local i = startBeat
  for _, gn in ipairs(groupNames) do
    local ng = NoteGroup(gn, i, self.player)
    local dur = ng.getDuration()
    table.insert(self.noteGroups, NoteGroup(gn, i, self.player))
    i = i + dur
  end
end

function BuildSection:update(dt)
    local sectionFinished = true
    for _, ng in ipairs(self.noteGroups) do
      ng:update(dt)
      if not ng.completed then
        sectionFinished = false
      end
    end

    if sectionFinished and next(self.noteGroups) ~= nil then
      for _, ng in ipairs(self.noteGroups) do
        ng:destruct()
      end
      self.noteGroups = {}
      self.player:resetHealth()
    end
end

function BuildSection:draw()
    for _, ng in ipairs(self.noteGroups) do
      ng:draw()
    end
end
