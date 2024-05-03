UI = require("ui")
engine.name = "PolyPerc"
MusicUtil = require("musicutil")
arpy_ = include("lib/arpy")

dial = {}
-- UI.Dial.new (x, y, size, value, min_value, max_value, rounding, start_value, markers, units, title)
dial[1] = UI.Dial.new(10, 3, 20, 50, 0, 100, 1, 0, {0}, 'hz')
dial[2] = UI.Dial.new(55, 3, 20, 50, 0, 100, 1, 0, {0}, 'hz')
dial[3] = UI.Dial.new(55, 34, 20, 50, 0, 100, 1, 0, {0}, 'hz')

screen.aa(1) -- provides smoother screen drawing

function init()
    print("hello, world")
    chords = {
        {0, 4, 7}, -- C major
        {-1, 2, 7}, -- G major
        {0, 4, 9}, -- A minor 
        {-1, 4, 11}, -- E minor 
    }
    chord_index = 1
    engine.amp(1)
    print("running function")

    arpys = {}
    table.insert(arpys,arpy_:new({
        id=1,
        division = {2,2,2,2,2,2,2,2,2,2,2,2},
        notes = {1,2,3,1,2,3},
        note_adds={0,0}
    }))
    table.insert(arpys,arpy_:new({
        id=2,
        division = {2,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        notes = {1,1,1,1,2,2,2,2,2,3,3,3},
        note_adds={0,1,2,-1,0,4,0,4}
    }))
    table.insert(arpys,arpy_:new({
        id=3,
        division = {2,1,1,1,1,1,1,1,1,1,2,1},
        notes = {2,3,2,2,2},
        note_adds={2}
    }))
    local notes_current={0}
    local beat_current = 15
    clock.run(function()
      while true do 
        clock.sync(1/4)
        beat_current = beat_current + 1
        if (beat_current % 16 == 0) then 
          chord_index = (chord_index % #chords) + 1
          notes_current = chords[chord_index]
          engine.cutoff(1000)
          engine.release(4)
          engine.amp(0.7)
          -- for i, n in ipairs(notes_current) do 
          --     engine.hz(MusicUtil.note_num_to_freq(n + 48))
          -- end
        end
        for _, arpy in ipairs(arpys) do 
          arpy:emit(notes_current)
        end
      end
    end)

    clock.run(function()
      while true do 
          redraw()
          clock.sleep(1/30)
      end
  end)
end

function enc(n,d)
  dial[n]:set_value_delta(d)
end
  
function redraw()
  screen.clear()
  screen.fill()
  -- dials need to be redrawn to display:
  for i = 1,3 do
    dial[i]:redraw()
  end
  screen.update()
end
