
--[[
@module tcpclient
@summary 事件式TCP客户端
@version 1.0.9
@date    2024.01.08
@author  wendal
@tag LUAT_USE_NETWORK
@demo ntrip
@usage
-- 具体用法请查阅demo
]]

local tcpclient = {}

local client_opts = {}

function tcpclient.create(opts)
    local tcpc = {}
    tcpc.netc = socket.create(opts.adapter, function(sc, event)
        local estr = nil
        if event == socket.TX_OK then
            estr = "sent"
        end
        if event == socket.CLOSED then
            estr = "closed"
        end
        if event == socket.ON_LINE then
            estr = "estr"
        end
        if event == socket.CLOSED then
            estr = "closed"
        end
        if estr then
            table.insert(tcpc.events, estr)
            sys.publish(tcpc.topic, estr)
        end
    end)
    if not tcpc.netc then
        log.error("tcpclient", "create socket failed!!!")
        return
    end
    socket.config(tcpc.netc, opts.local_port, opts.is_udp, opts.is_ssl, 
        opts.keep_idle, opts.keep_interval, opts.keep_cnt,
        opts.server_cert, opts.client_cert, opts.client_key, opts.client_password
    )
    if opts.debug then
        socket.debug(netc, true)
    end
    tcpc.events = {}
    tcpc.rxbuff = zbuff.create(1024)
    tcpc.topic = tostring(tcpc.rxbuff)
    setmetatable(tcpc, tcpc)
    return tcpc
end

function client_opts:connect(host, port, timeout)
    self:events = {}
    self:rxbuff:del()
    if not socket.connect(self:netc, host, port) then
        return
    end
    if timeout and timeout > 0 then
        if sys.waitUntil(self:topic, timeout) then
            local event = table.remove(self:events, 1)
            if event == "conack" then
                return true
            end
        end
    end
    return true
end

function client_opts:rx(buff, flags, limit)
    return socket.rx(self:netc, buff, flags, limit)
end

function client_opts:tx(buff, flags)
    return socket.tx(self:netc, buff, flags)
end

function client_opts:close(timeout)
    socket.close(self:netc)
    if timeout and timeout > 0 then
        if sys.waitUntil(self:topic,timeout) then
            local event = table.remove(self:events, 1)
            if event == "closed" then
                return true
            end
        end
    end
    return true
end

function client_opts:release()
    socket.release(self:netc)
    return true
end



function client_opts:select(timeout)
    if #self:events > 0 then
        return table.remove(self:events, 1)
    end
    local result, data = sys.waitUntil(self:topic, timeout)
    if result then
        return table.remove(self:events, 1)
    end
end

return tcpclient
