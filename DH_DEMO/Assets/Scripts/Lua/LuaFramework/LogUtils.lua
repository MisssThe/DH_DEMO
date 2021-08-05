local LogUtils = {}
local DEBUG = true
local function getPrintString( ... )
    local result = ""
    local paramCount = select('#', ...)
    for i = 1, paramCount do
        local v = select(i, ...)
        result = result .. tostring(v) .. "\t"
    end
    return result
end

function LogUtils.info(msg,color)
    if DEBUG then
        msg = LogUtils.obj2String(msg)
        UE.Debug.Log(msg)
    end
end

function LogUtils.error(msg)
    msg = LogUtils.obj2String(msg)
    UE.Debug.LogError(msg)

end

function LogUtils.warning(msg)
    msg = LogUtils.obj2String(msg)
    UE.Debug.LogWarning(msg)
end

function LogUtils.obj2String(msg)
    local str = ""
    if type(msg) == "table" then
        local cache = {}
        for k, v in pairs(msg) do
            str = string.format("[%s] = ",k)
            if type(v) == "table" then
                str = str .. LogUtils.obj2String(v)
            else
                str = str .. tostring(v)
            end
            table.insert(cache,str)
        end
        str = "{" .. table.concat(cache," ,") .. "}"
    else
        str = tostring(msg)
    end
    return str
end

return LogUtils