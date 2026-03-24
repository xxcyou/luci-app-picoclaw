-- Copyright 2021-2026 LIKE2000-ART
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.picoclaw", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/picoclaw") then
        return
    end

    entry({"admin", "services", "picoclaw"}, firstchild(), "PicoClaw AI助手", 59).dependent = true
    entry({"admin", "services", "picoclaw", "config"}, cbi("picoclaw/config"), "基本设置", 10)
    entry({"admin", "services", "picoclaw", "manual"}, cbi("picoclaw/manual"), "手动设置", 15)
    entry({"admin", "services", "picoclaw", "log"}, cbi("picoclaw/log"), "日志", 20)
end