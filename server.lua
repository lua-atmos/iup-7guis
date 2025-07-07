local s = require "atmos.env.socket"
local socket = require "socket"

call(function ()
    local srv = assert(s.xtcp())
    assert(srv:bind("*", 22222))
    assert(s.xlisten(srv))
    print("listen", srv:getsockname())

    local clis = tasks()
    while true do
        local cli = assert(s.xaccept(srv))
        print("accept", cli:getpeername())
        spawn_in(clis, function ()
            while true do
                local v = s.xrecv(cli)
                assert(v == '?')
                local x = (math.random() >= 0.5) and '1' or '0'
                await(clock{s=2})
                cli:send(x)
            end
        end)
    end
end)
