UI = require("ui")
engine.name = "PolyPerc"
MusicUtil = require("musicutil")
arpy_ = include("lib/arpy")
minor_or_major = "minor"
key_change = -0.5
do_key_change = -1
dial = {}
-- UI.Dial.new (x, y, size, value, min_value, max_value, rounding, start_value, markers, units, title)
dial[1] = UI.Dial.new(10, 3, 20, 50, 0, 100, 1, 0, {0}, 'hz')
dial[2] = UI.Dial.new(55, 3, 20, 50, 0, 100, 1, 0, {0}, 'hz')
dial[3] = UI.Dial.new(55, 34, 20, 50, 0, 100, 1, 0, {0}, 'hz')

screen.aa(1) -- provides smoother screen drawing
 
function init() 
    print("hello, world")
    -- minor_or_major = "major"
    -- chords = {
    --   -- A minor
    --   {-3, 4, 12},
    --   -- F major
    --   {5-12, 0, 14},
    --   -- C major
    --   {0,  7, 16},
    --   -- E minor
    --   {-1, 4, 7+12},
    --   -- A minor
    --   {-3, 4, 12},
    --   -- F major
    --   {5-12, 0, 14},
    --   -- C major
    --   {0, 7, 16},
    --   -- G major
    --   {-1,7, 14},
    -- }
    minor_or_major = "minor"
    chords = {
      -- C minor
      {0, 3, 7},
      -- Gmin
      {-2,2,7},
      -- Ab major
      {-4,0,3 },
      -- F minor
      {-7,-4,0},
      -- G minor
      {-5,-2,2},
      -- C minor
      {0, 3, 7},
      -- Eb6
      {7-12,-2,3},
      -- Bb add9
      {-2,2,5},
    }
    minor_or_major = "major"
    chords = {
      -- A minor
      {-3, 4, 12},
      -- E minor
      {-5, -1, 4,},
      -- F major
      {5-12, 0, 14},
      -- C major
      {0,  7, 16},
      -- A minor
      {-3, 4, 12},
      -- E minor
      {-1, 4, 7+12},
      -- F major
      {5-12, 0, 14},
      -- G major
      {-1,7, 14},
    }
    -- chords = {
    --     {0, 4, 7}, -- C major
    --     {2,-1, 7}, -- G major
    --     {4,0, 9}, -- A minor 
    --     {-1, 4, 11}, -- E minor 
    -- }
  --   chords = {
  --     {4, 7, 11},  -- E major
  --     {0, 4, 9},    -- A minor
  --     {-1, 2, 6},  -- B minor
  --     {0, 4, 7-12},    -- C major
  --     {0, 4, 9-12},    -- A minor
  --     {0, 4-12, 7-12},    -- C major
  --     {0-12, 4, 9-12},    -- A minor
  --     {2,6,9-12 }, -- D major
  -- }
  
    chord_index = 0
    engine.amp(1)
    print("running function")

    arpys = {}
    table.insert(arpys,arpy_:new({
        id=1,
        division = {2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        notes = {1},
        note_adds={0}
    }))
    table.insert(arpys,arpy_:new({
        id=2,
        division = {2},
        notes = {1,2,3,1,2,3,2,1,2,3,1,2,3,2,1,2},
        note_adds={0,0,0,12,12,12,12,12,24,24,24,24,12,12,12,0},--, 12,0,0,0,12,24,24,12, 12,0,0,0,12,12,12, 12,14}
    }))
    table.insert(arpys,arpy_:new({
        id=3,
        division = {2,1,2,2,2},
        notes = {1,1,3,2,2,3,2,1,2,3,1,2,3,2,1,2},
        note_adds={0,0},--, 12,0,0,0,12,24,24,12, 12,0,0,0,12,12,12, 12,14}
    }))
    -- table.insert(arpys,arpy_:new({
    --     id=3,
    --     division = {1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1},
    --     notes = {3},
    --     note_adds = {12 }
    -- }))
  --   table.insert(arpys,arpy_:new({
  --     id=2,
  --     division = {2,2,2,2,2,2,2,2,2,2,2,2},
  --     notes = {1,2,3,1,2,3},
  --     note_adds={0,0}
  -- }))
  -- table.insert(arpys,arpy_:new({
  --       id=3,
  --       division = {2,1,1,1,1,1,1,1,1,1,2,1},
  --       notes = {2,3,2,2,2},
  --       note_adds={2}
  --   }))
    local notes_current={0}
    local beat_current = 31
    clock.run(function()
      while true do 
        clock.sync(1/8)
        beat_current = beat_current + 1
        if (beat_current % 32 == 0) then 
          chord_index = (chord_index % #chords) + 1
          if chord_index==1 then 
            do_key_change = do_key_change +1
            if (do_key_change==2) then 
            -- key_change = key_change + 0.1
              do_key_change = 1
              end
          end
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
