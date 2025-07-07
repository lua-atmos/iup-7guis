require "atmos.env.iup"

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

call(function ()
    every(btn_count,'action', function ()
        addCount()
        txt_count.value = getCount()
    end)
end)
