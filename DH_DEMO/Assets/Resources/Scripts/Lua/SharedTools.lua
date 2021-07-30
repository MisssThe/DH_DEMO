-- 存放所有工具方法
_g = _G

-- 存放CS代码中的数据
cs_self = {}

-- 实现创建全局变量功能
Global = {}
setmetatable(Global,
    {
        __newindex = function(name,value)
            rawset(_g,name,value)
        end,
        __index = function(name)
            return rawget(_g,name)
        end
    }
)

-- 实现关闭直接创建全局变量功能
local function DisableGlobal()
    setmetatable(_g,
        {
            __newindex = function(_,name,value)
                print("try to create globa variable:" .. name)
            end
        }
    )
end
DisableGlobal()

-- 实现创建枚举功能
function Global.CreateEnum(t)
    local enum_table = {}
    for i,v in ipairs(t)
    do
        enum_table[v] = i
        print("create enum table succed!")
    end
    return enum_table
end