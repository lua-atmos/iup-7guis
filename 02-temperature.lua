require "atmos.env.iup"
require("iuplua")

function attrib2number(value)
  if not value or value == "" then
    return 0
  else
    return tonumber(value)
  end
end

function fahrenheit2celcius(temp)
  return (temp - 32) * (5./9.)
end

function celcius2fahrenheit(temp)
  return temp * (9./5.) + 32
end

--********************************** Main *****************************************

txt_celcius = iup.text{size = "60", mask = "[+/-]?(/d+/.?/d*|/./d+)"}
lbl_celcius = iup.label{title = "Celcius = "}

txt_fahrenheit = iup.text{size = "60", mask = "[+/-]?(/d+/.?/d*|/./d+)"}
lbl_fahrenheit = iup.label{title = "Fahrenheit"}

dlg = iup.dialog{iup.hbox{txt_celcius, lbl_celcius, txt_fahrenheit, lbl_fahrenheit; ngap = "10", alignment = "ACENTER"}, title = "TempConv", margin = "10x10"}

dlg:showxy( iup.CENTER, iup.CENTER )

call(function ()
    par(function ()
        every(txt_celcius,'value', function ()
            txt_fahrenheit.value = celcius2fahrenheit(attrib2number(txt_celcius.value))
        end)
    end, function ()
        every(txt_fahrenheit, function ()
            txt_celcius.value = fahrenheit2celcius(attrib2number(txt_fahrenheit.value))
        end)
    end)
end)
