local fs = require "nixio.fs"
local sys = require "luci.sys"

m = Map("picoclaw", "PicoClaw 日志")

s = m:section(TypedSection, "basic", "日志查看器")
s.anonymous = true
s.addremove = false

logview = s:option(TextValue, "_log")
logview.rows = 25
logview.wrap = "off"
logview.readonly = "readonly"
logview.description = "PicoClaw 运行日志"

function logview.cfgvalue(self, section)
    local log = fs.readfile("/var/log/picoclaw.log")
    if log then
        local lines = {}
        for line in log:gmatch("[^\r\n]*") do
            table.insert(lines, line)
        end
        if #lines > 1000 then
            lines = {unpack(lines, #lines - 999)}
        end
        return table.concat(lines, "\n")
    else
        return "日志文件不存在或为空"
    end
end

-- 清空日志按钮
clear_btn = s:option(Button, "_clear", "清空日志")
clear_btn.inputtitle = "清空"
clear_btn.inputstyle = "reset"
function clear_btn.write(self, section)
    fs.writefile("/var/log/picoclaw.log", "")
end

return m
