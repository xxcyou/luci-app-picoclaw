-- Copyright 2021-2026 LIKE2000-ART
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")

local fs = require "nixio.fs"
local uci = luci.model.uci.cursor()
local m, s, o

m = Map("picoclaw", translate("PicoClaw Manual Settings"),
    translate("Configure manual settings for PicoClaw AI Assistant."))

-- Manual settings section
s = m:section(NamedSection, "manual", "manual")
s.title = translate("🔧 Manual Configuration")

o = s:option(TextValue, "config_content", translate("Configuration Content"))
o.description = translate("Edit the picoclaw configuration file directly.")
o.rows = 20
o.wrap = "off"

function o.cfgvalue(self, section)
    return fs.readfile("/etc/picoclaw/config.json") or ""
end

function o.write(self, section, value)
    if value then
        fs.writefile("/etc/picoclaw/config.json", value)
        luci.sys.call("/etc/init.d/picoclaw reload")
    end
end

return m