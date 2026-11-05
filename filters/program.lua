-- program.lua
-- Builds the schedule and talk details for the PDF (Typst) output.
--
-- Data comes from:
--   * schedule.yml (loaded as metadata by _quarto.yml): event details,
--     sessions and talk folders
--   * talks/<session-folder>/*.md: one file per talk (files starting with "_" are skipped)
--
-- Placeholders in the .qmd files:
--   ::: {.program-schedule}  -> event header + schedule table
--   ::: {.program-talks}     -> talk details, grouped by session folder
--   ::: {.todo}              -> highlighted "to do" box
--
-- The Typst functions called here (event-header, schedule-table, ...) are
-- defined in theme/layout.typ.

local stringify = pandoc.utils.stringify

-- Typst output helpers ---------------------------------------------------

local function typst_string(s)
  s = s:gsub("\\", "\\\\"):gsub('"', '\\"')
  return '"' .. s .. '"'
end

-- Convert pandoc blocks to a Typst content block: [ ... ]
local function typst_content(blocks)
  local out = pandoc.write(pandoc.Pandoc(blocks), "typst")
  out = out:gsub("^%s+", ""):gsub("%s+$", "")
  return "[" .. out .. "]"
end

local function typst_array(items)
  if #items == 0 then return "()" end
  return "(" .. table.concat(items, ", ") .. ",)"
end

-- pairs_list is an ordered list of { key, typst_value }
local function typst_dict(pairs_list)
  local parts = {}
  for _, kv in ipairs(pairs_list) do
    parts[#parts + 1] = kv[1] .. ": " .. kv[2]
  end
  return "(" .. table.concat(parts, ", ") .. ")"
end

-- Metadata helpers -------------------------------------------------------

local function as_inlines(value)
  if value == nil then return nil end
  local t = pandoc.utils.type(value)
  if t == "Inlines" then return value end
  if t == "Blocks" then return pandoc.utils.blocks_to_inlines(value) end
  local s = stringify(value)
  if s == "" then return nil end
  return pandoc.Inlines(s)
end

-- Metadata value -> Typst content, or `none` when missing/empty.
local function content_or_none(value)
  local inlines = as_inlines(value)
  if inlines == nil or #inlines == 0 then return "none" end
  return typst_content({ pandoc.Plain(inlines) })
end

local function as_list(value)
  if value == nil then return {} end
  if pandoc.utils.type(value) == "List" then return value end
  return { value }
end

local function read_file(path)
  local fh = io.open(path, "r")
  if not fh then return nil end
  local text = fh:read("a")
  fh:close()
  return text
end

-- Talks ------------------------------------------------------------------

local function speaker_typst(sp)
  return typst_dict({
    { "name", content_or_none(sp.name) },
    { "honorific", content_or_none(sp.honorific) },
    { "affiliation", content_or_none(sp.affiliation) },
    { "affiliation-short", content_or_none(sp["affiliation-short"]) },
  })
end

local function link_typst(link)
  return typst_dict({
    { "label", content_or_none(link.label) },
    { "url", typst_string(stringify(link.url or "")) },
  })
end

local function sorted_listing(dir)
  local ok, entries = pcall(pandoc.system.list_directory, dir)
  if not ok then return nil end
  table.sort(entries)
  return entries
end

local function load_talk(path, folder, file)
  local doc = pandoc.read(read_file(path), "markdown")
  local m = doc.meta

  local speakers, links = {}, {}
  for _, sp in ipairs(as_list(m.speakers)) do speakers[#speakers + 1] = speaker_typst(sp) end
  for _, l in ipairs(as_list(m.links)) do links[#links + 1] = link_typst(l) end

  return {
    file = folder .. "/" .. file,
    type = folder,
    order = tonumber(stringify(m.order or "")) or math.huge,
    title = content_or_none(m.title),
    speakers = typst_array(speakers),
    links = typst_array(links),
    abstract = #doc.blocks > 0 and typst_content(doc.blocks) or "none",
  }
end

-- Each subfolder of the talks folder is a session (e.g. talks/lightning-session/);
-- the folder a talk file sits in decides which session it belongs to.
local function load_talks(dir)
  local talks = {}
  local folders = sorted_listing(dir)
  if not folders then
    quarto.log.warning("program.lua: cannot read talks folder: " .. dir)
    return talks
  end

  for _, folder in ipairs(folders) do
    local files = not folder:match("^[_.]") and sorted_listing(pandoc.path.join({ dir, folder }))
    if files then
      for _, file in ipairs(files) do
        if file:match("%.md$") and not file:match("^_") then
          talks[#talks + 1] = load_talk(pandoc.path.join({ dir, folder, file }), folder, file)
        end
      end
    elseif folder:match("%.md$") and not folder:match("^_") then
      quarto.log.warning("program.lua: talks/" .. folder ..
        " is not in a session folder (e.g. talks/lightning-session/) and will not appear")
    end
  end

  -- Sort by `order`, then file name.
  table.sort(talks, function(a, b)
    if a.order ~= b.order then return a.order < b.order end
    return a.file < b.file
  end)
  return talks
end

local function talks_of_type(talks, talk_type)
  local out = {}
  for _, t in ipairs(talks) do
    if t.type == talk_type then out[#out + 1] = t end
  end
  return out
end

-- Placeholder builders ---------------------------------------------------

local function schedule_blocks(meta, talks)
  local ev = meta.event or {}

  local logos = {}
  for _, path in ipairs(as_list(ev.logos)) do
    logos[#logos + 1] = "image(" .. typst_string(stringify(path)) .. ", height: 100%)"
  end

  local header = "#event-header(" .. table.concat({
    "kicker: " .. content_or_none(ev.kicker),
    "title: " .. content_or_none(ev.title),
    "date: " .. content_or_none(ev.date),
    "time: " .. content_or_none(ev.time),
    "venue: " .. content_or_none(ev.venue),
    "note: " .. content_or_none(ev.note),
    "logos: " .. typst_array(logos),
  }, ",\n  ") .. ")"

  local rows = {}
  for _, s in ipairs(as_list(meta.sessions)) do
    local items = {}
    if s.talks then
      for _, t in ipairs(talks_of_type(talks, stringify(s.talks))) do
        items[#items + 1] = typst_dict({ { "title", t.title }, { "speakers", t.speakers } })
      end
    end
    rows[#rows + 1] = typst_dict({
      { "time", content_or_none(s.time) },
      { "title", content_or_none(s.title) },
      { "description", content_or_none(s.description) },
      { "kind", typst_string(s.kind and stringify(s.kind) or "session") },
      { "talks", typst_array(items) },
    })
  end

  local table_call = "#schedule-table(" .. typst_array(rows) .. ")"
  return pandoc.RawBlock("typst", header .. "\n\n" .. table_call .. "\n")
end

local function talk_detail_blocks(meta, talks)
  local blocks = pandoc.Blocks({})
  local known = {}

  for _, tt in ipairs(as_list(meta["talk-folders"])) do
    local id = stringify(tt.folder)
    known[id] = true
    local entries = {}
    for _, t in ipairs(talks_of_type(talks, id)) do
      entries[#entries + 1] = "#talk-entry(" .. table.concat({
        "title: " .. t.title,
        "speakers: " .. t.speakers,
        "links: " .. t.links,
        "abstract: " .. t.abstract,
      }, ",\n  ") .. ")"
    end
    if #entries > 0 then
      blocks:insert(pandoc.Header(1, as_inlines(tt.label) or id, pandoc.Attr("talks-" .. id)))
      blocks:insert(pandoc.RawBlock("typst", table.concat(entries, "\n\n")))
    end
  end

  for _, t in ipairs(talks) do
    if not known[t.type] then
      quarto.log.warning("program.lua: " .. t.file .. " is in folder '" .. t.type ..
        "', which is not listed under talk-folders in schedule.yml")
    end
  end
  return blocks
end

-- Main -------------------------------------------------------------------

function Pandoc(doc)
  if not quarto.doc.is_format("typst") then return nil end

  local dir = stringify(doc.meta["talks-dir"] or "talks")
  if not pandoc.path.is_absolute(dir) then
    local base = quarto.project.directory or pandoc.path.directory(quarto.doc.input_file)
    dir = pandoc.path.join({ base, dir })
  end
  local talks = load_talks(dir)

  doc.blocks = doc.blocks:walk({
    Div = function(div)
      if div.classes:includes("program-schedule") then
        return schedule_blocks(doc.meta, talks)
      elseif div.classes:includes("program-talks") then
        return talk_detail_blocks(doc.meta, talks)
      elseif div.classes:includes("todo") then
        return pandoc.RawBlock("typst", "#todo-box(" .. typst_content(div.content) .. ")")
      end
    end,
  })
  return doc
end
