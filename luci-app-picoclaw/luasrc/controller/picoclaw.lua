module("luci.controller.picoclaw", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/picoclaw") then
        return
    end

    entry({"admin", "services", "picoclaw"}, firstchild(), "PicoClaw", 59)
    entry({"admin", "services", "picoclaw", "config"}, cbi("picoclaw/config"), "基础设置", 10)
    entry({"admin", "services", "picoclaw", "advanced"}, cbi("picoclaw/advanced"), "高级配置", 15)
    entry({"admin", "services", "picoclaw", "log"}, cbi("picoclaw/log"), "日志查看", 20)
end
