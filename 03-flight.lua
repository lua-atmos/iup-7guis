require "atmos.env.iup"
require("iuplua")

function checkDateFormat(str_date)
	str_date = string.gsub(str_date, "^%s*(.-)%s*$", "%1")
	local check = string.find(str_date, "^%d?%d.%d?%d.%d%d%d%d$")
	if not check then
		return nil
	end
	local day, month, year = string.match(str_date, "(%d?%d).(%d?%d).(%d%d%d%d)")
	if day==nil or month==nil or year==nil then
		return nil
	end
	return 1, tonumber(day), tonumber(month), tonumber(year)
end

function validateDate(day, month, year)
	local leapYear = 0

	if day and day < 1 or day>31 or month and month < 1 or month > 12 then
		return nil
	end

	if year % 400 == 0 or year % 4 == 0 and year % 100 ~= 0 then
		leapYear = 1
	end

	if month == 2 and leapYear and day > 29 then
		return nil
	end

	if month == 2 and not leapYear and day > 28 then
		return nil
	end

	if (month == 4 or month == 6 or month == 9 or month == 11) and day > 30 then
		return nil
	end

  return 1
end

function startBeforeEnd(startDay, startMonth, startYear, endDay, endMonth, endYear)

  if startYear < endYear then
    return 1
  end

  if  startYear == endYear and startMonth < endMonth then
    return 1
  end

  if  startYear == endYear and startMonth == endMonth and startDay <= endDay then
    return 1
  end

  return nil
end

function checkDate(self)
	local check, day, month, year = checkDateFormat(self.value)
	if not check then
		self.valid = nil
		return
	end
	
	local valid = validateDate(day, month, year)
	if not valid then
		self.valid = nil
		return
	end

	self.valid = 1
	self.day = day
	self.month = month
	self.year = year
end

--********************************** Main *****************************************

lst_flight = iup.list{"one-way flight", "return flight"; dropdown = "YES", value = 1, expand = "HORIZONTAL"}
txt_startDate = iup.text{expand = "HORIZONTAL", value = "22.09.1957"}
txt_returnDate = iup.text{expand = "HORIZONTAL", active="NO", value = "22.09.1957"}
btn_book = iup.button{title = "Book", expand = "HORIZONTAL"}

dlg = iup.dialog{iup.vbox{lst_flight, txt_startDate, txt_returnDate, btn_book; gap="10"}, title = "Book Flight", size = "150", margin = "10x10"}

dlg:showxy( iup.CENTER, iup.CENTER )

function One_Ok ()
    btn_book.active = 'YES'
    txt_returnDate.active = 'NO'
    txt_startDate.bgcolor = "255 255 255"
    local Next = par_or(function ()
        await(txt_startDate, 'value')
        checkDate(txt_startDate)
        if txt_startDate.valid then
            return One_Ok
        else
            return One_No
        end
    end, function ()
        await(lst_flight, 'value')
        return Two
    end, function ()
        await(btn_book, 'action')
        iup.Message (
            "Attention!",
            "You have booked a one-way flight on "..txt_startDate.value.."."
        )
        return One_Ok
    end)
    return Next()
end

function One_No ()
    btn_book.active = 'NO'
    txt_returnDate.active = 'NO'
    txt_startDate.bgcolor = "255 0 0"
    local Next = par_or(function ()
        await(txt_startDate, 'value')
        checkDate(txt_startDate)
        if txt_startDate.valid then
            return One_Ok
        else
            return One_No
        end
    end, function ()
        await(lst_flight, 'value')
        return Two_No
    end)
    return Next()
end

function Two ()
    checkDate(txt_startDate)
    checkDate(txt_returnDate)
    if txt_startDate.valid and txt_returnDate.valid and
        startBeforeEnd(txt_startDate.day, txt_startDate.month, txt_startDate.year, txt_returnDate.day, txt_returnDate.month, txt_returnDate.year)
    then
        return Two_Ok()
    else
        return Two_No()
    end
end

function Two_Ok ()
    btn_book.active = 'YES'
    txt_returnDate.active = 'YES'
    txt_startDate.bgcolor = "255 255 255"
    txt_returnDate.bgcolor = "255 255 255"
    local Next = par_or(function ()
        await(_or_({txt_startDate,'value'}, {txt_returnDate,'value'}))
        return Two
    end, function ()
        await(lst_flight, 'value')
        return One_Ok
    end, function ()
        await(btn_book, 'action')
        iup.Message (
            "Attention!",
            "You have booked a return flight on "..txt_startDate.value..  " and "..txt_returnDate.value.."."
        )
        return Two_Ok
    end)
    return Next()
end

function Two_No ()
    btn_book.active = 'NO'
    txt_returnDate.active = 'YES'
    txt_startDate.bgcolor = (txt_startDate.valid and "255 255 255") or "255 0 0"
    txt_returnDate.bgcolor = (txt_returnDate.valid and "255 255 255") or "255 0 0"
    local Next = par_or(function ()
        await(_or_({txt_startDate,'value'}, {txt_returnDate,'value'}))
        return Two
    end, function ()
        await(lst_flight, 'value')
        return Two_No
    end)
    return Next()
end

call(function ()
    One_Ok()
end)
