local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()
local sys = require "luci.sys"

m = Map("picoclaw", "PicoClaw 设置")

-- 主要开关
s = m:section(TypedSection, "basic", "基础设置")
s.anonymous = true
s.addremove = false

enabled = s:option(Flag, "enabled", "启用 PicoClaw")
enabled.default = "1"
enabled.description = "启用或禁用 PicoClaw 服务"

logger = s:option(Flag, "logger", "启用日志")
logger.default = "1"
logger.description = "记录 PicoClaw 运行日志"

delay = s:option(Value, "delay", "启动延迟 (秒)")
delay.datatype = "uinteger"
delay.default = "0"
delay.description = "服务启动前的延迟时间"

-- 网关设置
gw = m:section(TypedSection, "gateway", "网关设置")
gw.anonymous = true
gw.addremove = false

host = gw:option(Value, "host", "监听地址")
host.default = "0.0.0.0"
host.description = "PicoClaw 监听的 IP 地址"

port = gw:option(Value, "port", "监听端口")
port.datatype = "port"
port.default = "18790"
port.description = "PicoClaw 监听的端口号"

-- 工作区设置
agent = m:section(TypedSection, "agent", "工作区设置")
agent.anonymous = true
agent.addremove = false

workspace = agent:option(Value, "workspace", "工作目录")
workspace.default = "/opt/picoclaw/workspace"
workspace.description = "PicoClaw 的工作目录路径"

restrict = agent:option(Flag, "restrict_to_workspace", "限制工作区访问")
restrict.default = "0"
restrict.description = "限制 PicoClaw 只能访问工作目录内的文件"

-- 心跳设置
hb = m:section(TypedSection, "heartbeat", "心跳设置")
hb.anonymous = true
hb.addremove = false

hb_enabled = hb:option(Flag, "enabled", "启用心跳")
hb_enabled.default = "1"
hb_enabled.description = "定期发送心跳信号"

interval = hb:option(Value, "interval", "心跳间隔 (分钟)")
interval.datatype = "uinteger"
interval.default = "30"
interval.description = "心跳信号发送的时间间隔"

-- 服务控制按钮
ctrl = m:section(TypedSection, "control", "服务控制")
ctrl.anonymous = true
ctrl.addremove = false

restart_btn = ctrl:option(Button, "_restart", "重启 PicoClaw")
restart_btn.inputtitle = "重启服务"
restart_btn.inputstyle = "apply"
function restart_btn.write(self, section)
    luci.sys.call("/etc/init.d/picoclaw restart >/dev/null 2>&1 &")
end

return m
