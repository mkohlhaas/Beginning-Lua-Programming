-- This file contains some of the functions (and one of the
-- tables) defined in Chapter 5.  They can be individually
-- cut-and-pasted into an interpreter session, or you can
-- run the whole file and access them from the interpreter
-- by using lua's -i option or the dofile function.

-- Prints a report of posts per user:
function Report(Users)
  print("USERNAME      NEW POSTS  REPLIES")
  for Username, User in pairs(Users) do
    print(string.format("%-15s  %6d   %6d", Username, User.NewPosts, User.Replies))
  end
end

-- Report({ arundelo = {NewPosts = 39, Replies = 19}, kwj = {NewPosts = 22, Replies = 81}, leethax0r = {NewPosts = 5325, Replies = 0}})
--
-- The output should be this:
-- USERNAME      NEW POSTS  REPLIES
-- arundelo             39       19
-- leethax0r          5325        0
-- kwj                  22       81

-- A workalike of the print function:
function Print(...)
  local ArgCount = select("#", ...)
  for I = 1, ArgCount do
    -- Only print a separator if one argument has already been printed:
    if I > 1 then
      io.write("\t")
    end
    io.write(tostring(select(I, ...)))
  end
  io.write("\n")
end

-- Returns Str without any whitespace or separators, or nil
-- if Str doesn't satisfy a simple validity test:
function ValidateCreditCard(Str)
  Str = string.gsub(Str, "[ /,.-]", "")
  return string.find(Str, "^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") and Str
end

-- > =ValidateCreditCard(“1234123412341234”)
-- 1234123412341234
-- > =ValidateCreditCard(“1234 1234 1234 1234”)
-- 1234123412341234
-- > ValidateCreditCard(“1234-1234-1234-1234”)
-- 1234123412341234
-- > =ValidateCreditCard(“1234-1234-1234-123”)
-- nil
-- > =ValidateCreditCard(“221B Baker Street”)
-- nil

-- Squeezes whitespace:
function Squeeze(Str)
  return (string.gsub(Str, "%s+", " "))
end

-- A table of test strings (for Squeeze):
TestStrs = {
  "nospaces",
  "alpha bravo charlie",
  "   alpha   bravo   charlie   ",
  "\nalpha\tbravo\tcharlie\na\tb\tc",
  [[
    alpha
    bravo
    charlie]]}

-- Trims trailing whitespace:
function TrimRight(Str)
  return (string.gsub(Str, "%s+$", ""))
end

-- for _, TestStr in ipairs(TestStrs) do
-- io.write(“UNSQUEEZED: <”, TestStr, “>\n”)
-- io.write(“ SQUEEZED: <”, Squeeze(TestStr), “>\n\n”)
-- end

-- The output should be as follows:
-- UNSQUEEZED: <nospaces>
--   SQUEEZED: <nospaces>
-- UNSQUEEZED: <alpha bravo charlie>
--   SQUEEZED: <alpha bravo charlie>
-- UNSQUEEZED: <   alpha   bravo   charlie   >
--   SQUEEZED: < alpha bravo charlie >
-- UNSQUEEZED: <
-- alpha bravo charlie
-- a     b     c>
--   SQUEEZED: < alpha bravo charlie a b c>
-- UNSQUEEZED: <    alpha
--     bravo
--     charlie>
-- SQUEEZED: < alpha bravo charlie>

-- Trims trailing whitespace (avoiding the backtracking done by the previous version):
function TrimRight(Str)
  -- By searching from the end backwards, find the position
  -- of the last nonwhitespace character:
  local I = #Str
  while I > 0 and string.find(string.sub(Str, I, I), "%s") do
    I = I - 1
  end
  return string.sub(Str, 1, I)
end

-- Returns the ordinal form of N:
function Ordinal(N)
  N = tonumber(N)
  local Terminator = "th"
  assert(N > 0, "Ordinal only accepts positive numbers")
  assert(math.floor(N) == N, "Ordinal only accepts integers")
  if string.sub(N, -2, -2) ~= "1" then
    local LastDigit = N % 10
    if LastDigit == 1 then
      Terminator = "st"
    elseif LastDigit == 2 then
      Terminator = "nd"
    elseif LastDigit == 3 then
      Terminator = "rd"
    end
  end
  return N .. Terminator
end

-- Returns a user-friendly version of a date string.  (Assumes its argument is a valid date formatted yyyy-mm-dd.)
function FriendlyDate(DateStr)
  local Year, Month, Day = string.match(DateStr, "^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  Month = ({"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"})[tonumber(Month)]
  return Month .. " " .. Ordinal(Day) .. ", " .. Year
end

-- Turns a string of HTML into an array of tokens. (Each token is a tag or a string before or after a tag; literal
-- open angle brackets cannot occur outside of tags, and literal close angle brackets cannot occur inside them.)
function TokenizeHtml(Str)
  local Ret = {}
  -- Chop off any leading non-tag text:
  local BeforeFirstTag, Rest = string.match(Str, "^([^<]*)(.*)")
  if BeforeFirstTag ~= "" then
    Ret[1] = BeforeFirstTag
  end
  -- Get all tags and anything in between or after them:
  for Tag, Nontag in string.gmatch(Rest, "(%<[^>]*%>)([^<]*)") do
    Ret[#Ret + 1] = Tag
    if Nontag ~= "" then
      Ret[#Ret + 1] = Nontag
    end
  end
  return Ret
end

-- > Html = “<p>Some <i>italicized</i> text.</p>”
-- > for _, Token in ipairs(TokenizeHtml(Html)) do print(Token) end
-- <p>
-- Some
-- <i>
-- italicized
-- </i>
-- text.
-- </p>
