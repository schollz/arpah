local Arpy={}
local MusicUtil = require("musicutil")

function Arpy:new(args)
  local m=setmetatable({},{
    __index=Arpy
  })
  local args=args==nil and {} or args
  for k,v in pairs(args) do
    m[k]=v
  end
  m:init()
  return m
end

function Arpy:init()
    self.division_index = 0
    self.note_index = 0
    self.note_add_index = 0
end

function Arpy:emit(notes)
    self.division_index = (self.division_index % #self.division) + 1
    if self.division[self.division_index]==2 then 
        self.note_index = (self.note_index % #self.notes) + 1
        self.note_add_index = (self.note_add_index % #self.note_adds) + 1
        local note = notes[self.notes[self.note_index]]
        note = MusicUtil.snap_note_to_array(note + self.note_adds[self.note_add_index]+24, MusicUtil.generate_scale(0, minor_or_major, 8))
        engine.cutoff(2000)
        engine.release(1)
        engine.amp(1)
        engine.hz(MusicUtil.note_num_to_freq(note + 48))
        crow.output[self.id].volts = (note-12)/12 + key_change
        -- crow.output[self.id].volts = 2
        -- print(self.id,note/12)
    end
end

return Arpy
