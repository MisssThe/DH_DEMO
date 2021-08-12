-- require("app.Global")
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
    end
    return enum_table
end

-- 实现创建全局变量功能
Global = {}
setmetatable(Global,
    {
        _g,
        __newindex = function(_,name,value)
            rawset(_g,name,value)
        end,
        __index = function(_,name)
            return rawget(_g,name)
        end
    }
)

-- 返回一个包含基本功能的list
List = {}
List.real_list = {}
List.count = 0
List.__index = List
List.key = nil
-- 添加数据
function List:Add(key,value)
    if (key ~= nil and value ~= nil) then
        self.real_list[key] = value
        self.count = self.count + 1
    end
end
-- 删除数据
function List:Delete(key)
    if (key ~= nil) then
        self.real_list[key] = nil
        self.count = self.count - 1;
    end
end
-- 查找数据
function List:Search(key)
    return self.real_list[key]
end
-- 清空数据
function List:Clear()
    self.real_list = nil
    self.real_list = {}
    self.count = 0
    self:InitIter()
end
-- 打印所有数据
function List:Print()
    for k,v in pairs(self.real_list)
    do
        print("key:" .. k .. ",value:" .. v)
    end
end
-- 获取迭代
List.index = 1
function List:Iterator()
    if (self.index > self.count) then
        return nil,nil
    end
    self.index = self.index + 1
    self.key = next(self.real_list,self.key)
    -- if ( self:Search(self.key) == nil) t
    return self:Search(self.key),(self.key ~= nil)
end
function List:InitIter()
    self.key = nil
    self.index = 1
end
-- 返回复制体
function List:Copy()
    self:InitIter()
    local flag = true
    local value = nil
    local temp_list = List:New()
    for i,v in pairs(self.real_list)
    do
        temp_list:Add(i,v)
    end
    return temp_list
end
-- 实例化
function List:New()
    local temp = {}
    setmetatable(temp,List)
    return temp
end

-- 返回一个支持删除的array
Array = {}
Array.real_array = {}
Array.count = 0
Array.index = 0
Array.__index = Array
-- 实例化
function Array:New()
    local temp = {}
    setmetatable(temp,Array)
    return temp
end
-- 添加数据
function Array:Add(v)
    if v ~= nil then
        self.real_array[self.index] = v
        self.index = self.index + 1
        self.count = self.count + 1
    end
end
-- 删除数据
function Array:Delete(index)
    if self.real_array[index] ~= nil then
        for i = index,self.count,1
        do
            self.real_array[i] = self.real_array[i + 1]
        end
        self.count = self.count - 1
    end
end
-- 获取数据
function Array:Get(index)
    -- if type(index) == "number" then
    return self.real_array[index]
    -- else
    --     local n = self:GetIndex(index)
    --     return self.real_array[n] 
    -- end
end
function Array:GetIndex(value)
    for i = 0,self.count,1 
    do
        if value == self.real_array[i] then
            return i
        end
    end
    return nil
end
-- 返回复制体
function Array:Copy()
    local temp_array = Array:New()
    for i = 0,self.count,1 do
        temp_array:Add(self:Get(i))
    end
    return temp_array
end

-- 静态变量
function StaticNum()
    local i = 0
    return function()
        i = i + 1
        return i
    end
end


-- 与选择对象相关的操作
Select = {}
-- 返回选择的对象
function GetSelectObj()
    return UE.EventSystems.EventSystem.current.currentSelectedGameObject
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

print("load shadred tools!")