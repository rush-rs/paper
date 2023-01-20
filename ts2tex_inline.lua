return function(ext, code)
    local escaped = string.gsub(code, "'", [['"'"']])
    local handle, err = io.popen('ts2tex inline ' .. ext .. " '" .. escaped .. "'")

    if not handle then
        print(err)
        os.exit(1)
    else
        tex.print(handle:read('*all'))
        handle:close()
    end
end
