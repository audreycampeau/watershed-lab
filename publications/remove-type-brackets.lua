-- remove-type-brackets.lua
-- Removes [Journal Article], [Book], etc. from bibliography output

function Str(el)
  -- Remove [Journal Article] and similar patterns
  local text = el.text
  text = text:gsub("%[Journal Article%]", "")
  text = text:gsub("%[Book%]", "")
  text = text:gsub("%[Conference Paper%]", "")
  text = text:gsub("%[Book Chapter%]", "")
  text = text:gsub("%[Thesis%]", "")
  
  -- Also handle with different bracket styles
  text = text:gsub("%(Journal Article%)", "")
  
  if text ~= el.text then
    return pandoc.Str(text)
  end
  return el
end
