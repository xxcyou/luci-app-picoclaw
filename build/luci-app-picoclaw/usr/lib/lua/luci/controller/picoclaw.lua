-- Copyright 2021-2026 LIKE2000-ART
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.picoclaw", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/picoclaw") then
        return
    end

    entry({"admin", "services", "picoclaw"}, firstchild(), _("PicoClaw"), 59).dependent = true
    entry({"admin", "services", "picoclaw", "config"}, cbi("picoclaw/config"), _("Base Setting"), 10)
    entry({"admin", "services", "picoclaw", "manual"}, cbi("picoclaw/manual"), _("Manual Settings"), 15)
    entry({"admin", "services", "picoclaw", "log"}, cbi("picoclaw/log"), _("Log"), 20)
end