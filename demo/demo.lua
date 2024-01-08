
local demo = {}
tcpclient = require("tcpclient")

sys.taskInit(function()
    sys.waitUntil("net_ready")
    
    local tcp_host = "112.125.89.8"
    local tcp_port = 46358
    local tcp_ssl = false

    local tcpc = tcpcliet.create(tcp_ssl)
    if not tcpc then
        log.error("tcpclient", "create tcp client failed")
        return
    end
    while 1 do
        if tcpclient:connect(tcp_host, tcp_port, 5000) then
            -- 连接成功, 发送初始化包
            tcpclient:tx("hello")
            while 1 do
                local event, param = tcpclient:select()
                if event == "custom" then
                    -- 自定义事件
                    if type(param) == "string" or type(param) == "userdata" then
                        tcpclient:tx(param)
                    end
                elseif event == "recv" then
                    while 1 do
                        local ok, len = tcpclient:rx(1024)
                        if not ok then
                            log.info("tcpclient", "recv failed")
                            break
                        end
                        if len < 1 then
                            break -- 接收完成
                        end
                        -- 处理数据
                    end
                elseif event == "sent" then
                    -- 发送完成
                    log.info("tcpclient", "sent")
                end
            end
        end
        tcpclient:close()
        sys.wait(5000)
    end

    tcpclient:release()
end)

sys.taskInit(function()
    -- local count = 1
    while 1 do
        sys.wait(5000)
        -- log.info("luatos", "hi", count, os.date())
        -- lua内存
        log.info("lua", rtos.meminfo())
        -- sys内存
        log.info("sys", rtos.meminfo("sys"))
        -- count = count + 1
    end
end)

return demo
