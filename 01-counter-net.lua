local atmos = require "atmos"
local env_sok = require "atmos.env.socket"
local env_iup = require "atmos.env.iup"

require("iuplua")

counter = 0

function addCount()
	counter = counter + 1
end

function getCount()
	return counter
end

--********************************** Main *****************************************

txt_count = iup.text{value = getCount(), readonly = "YES",  size = "60"}
btn_count = iup.button{title = "Count", size = "60"}

dlg = iup.dialog{iup.hbox{txt_count, btn_count; ngap = "10"}, title = "Counter", margin = "10x10"}

dlg:showxy( iup.CENTER, iup.CENTER )

atmos.env = {
    close = function ()
        env_sok.env.close()
        env_iup.env.close()
    end,
    loop = env_iup.loop,
}

local opts = { clock=false }
iup.SetIdle(function ()
    env_sok.step(opts)
end)

local socket = require "socket"
local s = env_sok

atmos.call(function ()
    local cli = assert(s.xtcp())
    assert(s.xconnect(cli, "localhost", 22222))

    while true do
        await(btn_count,'action')
        btn_count.active = "NO"

        cli:send "?"
        local v = s.xrecv(cli)
        assert(v=='0' or v=='1')

        btn_count.active = "YES"
        if v == '1' then
            addCount()
            txt_count.value = getCount()
        end
    end
end)
