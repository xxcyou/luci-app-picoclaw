-- Copyright 2021-2026 LIKE2000-ART
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")

local fs = require "nixio.fs"
local m, s, o

m = Map("picoclaw", translate("PicoClaw Log"),
    translate("View and manage PicoClaw logs."))

-- Log section
s = m:section(SimpleSection)
s.template = "picoclaw/log_view"

return m