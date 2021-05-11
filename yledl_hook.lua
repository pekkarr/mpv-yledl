-- Copyright 2021 Pekka Ristola

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

local msg = require 'mp.msg'
local utils = require 'mp.utils'

mp.add_hook("on_load", 9, function()
  msg.verbose('yle-dl hook')
  local url = mp.get_property("stream-open-filename", "")
  if (url:find("https?://%a+%.yle%.fi/") == 1) or (url:find("https?://yle%.fi/") == 1) then
    local command = { "yle-dl", "--showmetadata", url }
    msg.verbose("Running: " .. table.concat(command, ' '))
    local ret = mp.command_native({name = "subprocess",
                                   args = command,
                                   capture_stdout = true,
                                   capture_stderr = false})
    if ret.killed_by_us then
      return
    end
    if (ret.status < 0) or (ret.stdout == nil) or (ret.stdout == "") then
      msg.error("yle-dl failed to parse url")
      return
    end
    local json = utils.parse_json(ret.stdout)[1]
    local flavors = json["flavors"]
    table.sort(flavors, function(a, b) return a["bitrate"] > b["bitrate"] end)
    local best = flavors[1]
    mp.set_property("stream-open-filename", best["url"])
    mp.set_property("file-local-options/force-media-title", json["title"])
    for _, sub in ipairs(json["subtitles"]) do
      local lang = sub["language"]
      msg.verbose("Adding subtitles for " .. lang)
      mp.commandv("sub-add", sub["url"], "auto", sub["category"], lang)
    end
  else
    msg.verbose('not an areena url')
  end
end)
