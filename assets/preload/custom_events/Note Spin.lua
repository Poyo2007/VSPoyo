function onEvent(name, value1, value2)
  if name == 'Note Spin' then
    for i = 0,7 do
      noteTweenAngle('noteSpin'..i..'Tween', i, getPropertyFromGroup("strumLineNotes", i, "angle") + 180, value2, 'cubeOut')
    end
  end
end