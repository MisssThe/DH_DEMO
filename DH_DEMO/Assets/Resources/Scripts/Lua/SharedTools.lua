-- 存放所有工具方法
local _g = _G

-- 存放CS代码中的数据
cs_self = {}

-- 实现创建枚举功能
function CreateEnum(t)
    local enum_table = {}
    for i,v in ipairs(t)
    do
        enum_table[v] = i
        print("create enum table succed!")
    end
    return enum_table
end

-- 实现创建全局变量功能
Global = {}
setmetatable(Global,
    {
        _g,
        __newindex = function(_,name,value)
            print("create global value")
            rawset(_g,name,value)
        end,
        __index = function(_,name)
            return rawget(_g,name)
        end
    }
)

-- 返回一个包含基本功能的list
function CreateList()
    local list = {}
    list.real_list = {}
    list.count = 0
    -- 添加数据
    function list.Add(key,value)
        if (key ~= nil) then
            list.real_list[key] = value
            list.count = list.count + 1
        end
    end
    -- 删除数据
    function list.Delete(key)
        if (key ~= nil) then
            list.real_list[key] = nil
        end
    end
    -- 查找数据
    function list.Search(key)
        return list.real_list[key]
    end
    -- 清空数据
    function list.Clear()
        list.real_list = {}
        list.count = 0
    end
    -- 打印所有数据
    function list.Print()
        for k,v in pairs(list.real_list)
        do
            print("key:" .. k .. ",value:" .. v)
        end
    end
    return list
end

-- 实现关闭直接创建全局变量功能
local function DisableGlobal()
    setmetatable(_g,
        {
            __newindex = function(_,name,value)
                print("try to create globa variable:" .. name)
            end,
            __index = function(name)
                print("can not get value by this way")
            end
        }
    )
end
DisableGlobal()