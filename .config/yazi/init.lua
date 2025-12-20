local function format_time(time)
    if time == 0 then
        return ""
    end

    local format = os.date("%Y", time) == os.date("%Y")
        and "%b %d %H:%M"
        or "%b %d %Y"

    return os.date(format, time)
end

local function format_size(size)
    return size and ya.readable_size(size) or nil
end

function Linemode:time_and_size()
    local time = format_time(math.floor(self._file.cha.mtime or 0))
    local size = format_size(self._file:size())

    return size and (size .. " - " .. time) or time
end
