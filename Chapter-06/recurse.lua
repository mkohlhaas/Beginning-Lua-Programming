function Recurse(Count, Indent)
  Indent = Indent or ""
  if Count > 0 then
    io.write(Indent, "do\n")
    Recurse(Count - 1, Indent .. " ")
    io.write(Indent, "end\n")
  end
end

Recurse(299)

-- $ lua recurse.lua | lua
-- lua: stdin:200: too many C levels (limit is 200) in main function near 'do'
