-- Pandoc-Lua-Filter für die Dozenten-Skripte (Zettel für die Übung).
-- * ::: aufgabe | loesung | hinweis | warnung | ergaenzung  -> farbige Boxen
-- * ```mermaid -> PNG via mermaid-cli (mmdc), Cache nach Inhalts-Hash
-- * ```sql mit "--8<-- "pfad:abschnitt"" -> Code aus docs/ einbinden
-- * [5 Min.]{.zeit} in Überschriften -> Zeit-Badge rechtsbündig

local cache = os.getenv("SKRIPT_CACHE") or "cache"
local docs  = os.getenv("SKRIPT_DOCS") or "docs"

local function esc(s)
  return (s:gsub("([&%%$#_{}])", "\\%1"))
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local t = f:read("a"); f:close(); return t
end

-- Mermaid -> PNG
local function mermaid(block)
  -- Druck: Schrift im Diagramm größer als auf der Webseite (0.6rem)
  local text = block.text:gsub("0%.6rem", "0.75rem")
  local h = pandoc.sha1(text)
  local mmd, png = cache .. "/" .. h .. ".mmd", cache .. "/" .. h .. ".png"
  if not read_file(png) then
    local f = assert(io.open(mmd, "w")); f:write(text); f:close()
    local ok = os.execute('mmdc -q -c "' .. cache .. '/../mermaid-config.json" -i "' .. mmd .. '" -o "' .. png .. '" -s 3 -b white')
    if not ok then error("mmdc fehlgeschlagen für " .. mmd) end
  end
  local maxh = block.attributes["maxh"] or "6.5cm"
  return pandoc.RawBlock("latex", "\\mmdimg[" .. maxh .. "]{" .. png .. "}")
end

-- Snippet-Einbindung (pymdownx.snippets-Syntax der Kurswebseite)
local function snippet(block)
  local spec = block.text:match('^%-%-8<%-%-%s+"([^"]+)"')
  if not spec then return nil end
  local path, name = spec:match("^(.-):([%w_%-]+)$")
  path = path or spec
  local text = read_file(docs .. "/" .. path)
  if not text then error("Snippet nicht gefunden: " .. path) end
  if name then
    local out, on = {}, false
    for line in (text .. "\n"):gmatch("(.-)\r?\n") do
      if line:match("%[start:" .. name .. "%]") then on = true
      elseif line:match("%[end:" .. name .. "%]") then on = false
      elseif on then out[#out + 1] = line end
    end
    text = table.concat(out, "\n")
  end
  text = text:gsub("[ \t]*%-%- %(%d+%)!", "")  -- Annotationsmarken entfernen
  text = text:gsub("%s+$", "")
  -- Zu lange Zeilen mit Endkommentar: Kommentar in eigene Zeile davor (sonst ragt er über den Rand)
  local out = {}
  for line in (text .. "\n"):gmatch("(.-)\r?\n") do
    local indent, code, comment = line:match("^(%s*)(%S.-)%s+%-%-%s?(.*)$")
    if #line > 92 and code and not code:match("^%-%-") and not code:find("'[^']*%-%-[^']*'") then
      out[#out + 1] = indent .. "-- " .. comment
      out[#out + 1] = indent .. code
    else
      out[#out + 1] = line
    end
  end
  text = table.concat(out, "\n")
  return pandoc.CodeBlock(text, block.attr)
end

function CodeBlock(block)
  if block.classes:includes("mermaid") then return mermaid(block) end
  if block.text:match("^%-%-8<%-%-") then return snippet(block) end
end

local boxes = {
  aufgabe    = { env = "boxaufgabe",    title = "Aufgabe" },
  loesung    = { env = "boxloesung",    title = "Musterlösung" },
  hinweis    = { env = "boxhinweis",    title = "Hinweis" },
  warnung    = { env = "boxwarnung",    title = "Nicht vergessen" },
  ergaenzung = { env = "boxergaenzung", title = "Ergänzung (nicht auf der Webseite)" },
  bs         = { env = "boxbs",         title = "Übergang ins betreute Selbststudium" },
}

function Div(div)
  for cls, b in pairs(boxes) do
    if div.classes:includes(cls) then
      local title = div.attributes["title"]
      local open = "\\begin{" .. b.env .. "}"
      if title then open = open .. "[" .. esc(title) .. "]" end
      -- Mindestplatz vor jeder Box: verhindert einsame Kopfzeile am Seitenende
      local res = { pandoc.RawBlock("latex", "\\needspace{" .. (div.attributes["platz"] or "6") .. "\\baselineskip}"),
                    pandoc.RawBlock("latex", open) }
      for _, x in ipairs(div.content) do res[#res + 1] = x end
      res[#res + 1] = pandoc.RawBlock("latex", "\\end{" .. b.env .. "}")
      return res
    end
  end
end

function Span(span)
  if span.classes:includes("zeit") then
    return pandoc.RawInline("latex", "\\zeit{" .. esc(pandoc.utils.stringify(span.content)) .. "}")
  end
end
