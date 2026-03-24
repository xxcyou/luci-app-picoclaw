-- Copyright 2021-2026 LIKE2000-ART
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")
require("luci.model.uci")

local fs = require "nixio.fs"
local uci = luci.model.uci.cursor()
local m, s, o

-- Load UCI configuration
m = Map("picoclaw", "PicoClaw AI助手",
    "PicoClaw是一个超轻量级AI助手，体积小、速度快、可部署在任何地方。")

-- Status section
s = m:section(SimpleSection)
s.template = "picoclaw/status"

-- Basic settings
s = m:section(NamedSection, "config", "basic")
s.title = "⚙️ 基础设置"

o = s:option(Flag, "enabled", "启用 PicoClaw")
o.description = "启用 PicoClaw 后台守护程序。"
o.default = "1"
o.rmempty = false

o = s:option(Value, "delay", "开机延时启动（秒）")
o.description = "延迟服务的启动以等待网络就绪。"
o.default = "0"
o.datatype = "uinteger"

-- Gateway settings
s = m:section(NamedSection, "gateway", "gateway")
s.title = "🌐 网关设置"

o = s:option(Value, "host", "监听地址")
o.description = "API 服务器绑定的 IP 地址（0.0.0.0 表示所有接口）。"
o.default = "0.0.0.0"
o.rmempty = false

o = s:option(Value, "port", "监听端口")
o.description = "PicoClaw 本地 API 控制面板的端口号。"
o.default = "18790"
o.datatype = "port"
o.rmempty = false

-- Agent settings
s = m:section(NamedSection, "agent", "agent")
s.title = "🤖 Agent 设置"

o = s:option(Value, "workspace", "工作目录路径")
o.description = "存储 AI 记忆、对话、任务和配置的绝对路径。例如：/opt/picoclaw/workspace"
o.default = "/opt/picoclaw/workspace"
o.rmempty = false

o = s:option(Flag, "restrict_to_workspace", "限制在工作目录 (沙盒模式)")
o.description = "强烈建议开启。防止 AI 读取或修改工作目录之外的系统文件。"
o.default = "0"
o.rmempty = false

-- Heartbeat settings
s = m:section(NamedSection, "heartbeat", "heartbeat")
s.title = "❤️ 心跳设置"

o = s:option(Flag, "enabled", "启用心跳")
o.description = "为活跃的通讯渠道（如 Telegram, Discord）发送定期的保活信号。"
o.default = "1"
o.rmempty = false

o = s:option(Value, "interval", "心跳间隔（分钟）")
o.default = "30"
o.datatype = "uinteger"

return m