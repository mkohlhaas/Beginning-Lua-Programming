function B()
  print(debug.traceback("B"))
end

function A()
  print(debug.traceback("A 1"))
  B()
  print(debug.traceback("A 2"))
end

A()

-- $ lua trace.lua
--
-- A 1
-- stack traceback:
-- 	trace.lua:6: in function 'A'
-- 	trace.lua:11: in main chunk
-- 	[C]: in ?
-- B
-- stack traceback:
-- 	trace.lua:2: in function 'B'
-- 	trace.lua:7: in function 'A'
-- 	trace.lua:11: in main chunk
-- 	[C]: in ?
-- A 2
-- stack traceback:
-- 	trace.lua:8: in function 'A'
-- 	trace.lua:11: in main chunk
-- 	[C]: in ?
