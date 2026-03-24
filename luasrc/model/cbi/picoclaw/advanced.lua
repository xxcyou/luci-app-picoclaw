local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()
local sys = require "luci.sys"

m = Map("picoclaw", "高级配置")

s = m:section(TypedSection, "basic", "JSON 配置编辑器")
s.anonymous = true
s.addremove = false

-- JSON 配置编辑器
json_config = s:option(TextValue, "_json_config")
json_config.rows = 25
json_config.wrap = "off"
json_config.description = "直接编辑 PicoClaw 的 JSON 配置文件"

function json_config.cfgvalue(self, section)
    local config_content = fs.readfile("/etc/picoclaw/config.json")
    if config_content then
        return config_content
    else
        return "{\n  \"error\": \"配置文件不存在\"\n}"
    end
end

function json_config.write(self, section, value)
    fs.writefile("/etc/picoclaw/config.json", value)
    sys.call("/etc/init.d/picoclaw restart >/dev/null 2>&1 &")
end

-- 格式化按钮
format_btn = s:option(Button, "_format", "格式化 JSON")
format_btn.inputtitle = "格式化"
format_btn.inputstyle = "apply"
function format_btn.write(self, section)
    local current_config = fs.readfile("/etc/picoclaw/config.json")
    if current_config then
        fs.writefile("/tmp/picoclaw_format.json", current_config)
        sys.call("python3 -m json.tool /tmp/picoclaw_format.json > /tmp/picoclaw_formatted.json 2>/dev/null && mv /tmp/picoclaw_formatted.json /etc/picoclaw/config.json")
    end
end

return m
