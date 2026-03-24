-- Copyright 2021-2026 LIKE2000-ART
-- Licensed to the public under the Apache License 2.0.

require("luci.sys")
require("luci.util")
require("luci.model.uci")

local fs = require "nixio.fs"
local uci = luci.model.uci.cursor()
local m, s, o

-- Load UCI configuration
m = Map("picoclaw", translate("PicoClaw"),
    translate("PicoClaw is an ultra-lightweight AI Assistant. Tiny, Fast, and Deployable anywhere."))

-- Status section
s = m:section(SimpleSection)
s.template = "picoclaw/status"

-- Basic settings
s = m:section(NamedSection, "config", "basic")
s.title = translate("⚙️ Basic Settings")

o = s:option(Flag, "enabled", translate("Enable PicoClaw"))
o.description = translate("Enable the PicoClaw background daemon.")
o.default = "1"
o.rmempty = false

o = s:option(Value, "delay", translate("Delayed Start (seconds)"))
o.description = translate("Delay the startup of the service to wait for network readiness.")
o.default = "0"
o.datatype = "uinteger"

-- Gateway settings
s = m:section(NamedSection, "gateway", "gateway")
s.title = translate("🌐 Gateway Settings")

o = s:option(Value, "host", translate("Listen Address"))
o.description = translate("The IP address the API server will bind to (0.0.0.0 for all interfaces).")
o.default = "0.0.0.0"
o.rmempty = false

o = s:option(Value, "port", translate("Listen Port"))
o.description = translate("The port number for the PicoClaw local API dashboard.")
o.default = "18790"
o.datatype = "port"
o.rmempty = false

-- Agent settings
s = m:section(NamedSection, "agent", "agent")
s.title = translate("🤖 Agent Settings")

o = s:option(Value, "workspace", translate("Workspace Path"))
o.description = translate("Absolute path to store AI memories, chats, tasks, and configurations. E.g., /opt/picoclaw/workspace")
o.default = "/opt/picoclaw/workspace"
o.rmempty = false

o = s:option(Flag, "restrict_to_workspace", translate("Restrict to workspace (Sandbox)"))
o.description = translate("Highly recommended. Prevents the AI from reading/modifying files outside the workspace directory.")
o.default = "0"
o.rmempty = false

-- Heartbeat settings
s = m:section(NamedSection, "heartbeat", "heartbeat")
s.title = translate("❤️ Heartbeat Settings")

o = s:option(Flag, "enabled", translate("Enable Heartbeat"))
o.description = translate("Send periodic keep-alive signals for active channels (e.g., Telegram, Discord).")
o.default = "1"
o.rmempty = false

o = s:option(Value, "interval", translate("Heartbeat Interval (minutes)"))
o.default = "30"
o.datatype = "uinteger"

return m