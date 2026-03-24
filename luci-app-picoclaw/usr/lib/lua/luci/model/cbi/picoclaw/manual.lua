-- Copyright 2021-2026 LIKE2000-ART
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")

local fs = require "nixio.fs"
local uci = luci.model.uci.cursor()
local m, s, o

m = Map("picoclaw", "📝 手动设置",
    "直接编辑 config.json 配置文件。保存后 PicoClaw 将自动重启。")

-- Manual settings section
s = m:section(NamedSection, "manual", "manual")
s.title = "🔧 手动配置"

o = s:option(TextValue, "config_content", "配置内容")
o.description = "使用高级 CodeMirror 编辑器直接修改 <code>config.json</code> 源文件。保存后服务将自动重启。"
o.rows = 25
o.wrap = "off"

function o.cfgvalue(self, section)
    return fs.readfile("/etc/picoclaw/config.json") or "{}"
end

function o.write(self, section, value)
    if value then
        -- Validate JSON before writing
        local temp_file = "/tmp/picoclaw_config_test.json"
        fs.writefile(temp_file, value)
        local json_valid = luci.sys.call("json_verify -q " .. temp_file .. " >/dev/null 2>&1")
        fs.unlink(temp_file)
        
        if json_valid == 0 then
            fs.writefile("/etc/picoclaw/config.json", value)
            luci.sys.call("/etc/init.d/picoclaw restart")
            return true
        else
            -- Handle invalid JSON
            luci.http.redirect(luci.http.getenv("REQUEST_URI"))
            return false
        end
    end
end

return m