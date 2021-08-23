require("Assets/Scripts/Lua/EventSystem.lua")

Global.UIModel = {}
UIModel.__index = UIModel
UIModel.data_list = {}
UIModel.flag = true
UIModel.max = 30
UIModel.num = 0

function UIModel:New(max)
    local temp = {}
    setmetatable(temp,UIModel)
    temp.num = 0
    temp.max = max
    return temp
end

function UIModel:Add(data_name,data)
    if data_name ~= nil and data ~= nil then
        if self.num < self.max then
            self.data_list[data_name] = data
            self.flag = true
            self.num = self.num + 1
            return true
        else
            print("添加失败qqqqqqqqqqqqqqqq")
            return false
        end
    end
end

function UIModel:DeleteByKey(key)
    if key ~= nil then
        print("删除物体")
        self.data_list[key] = nil
        self.flag = true
    end
    self.num = self.num - 1
end
function UIModel:DeleteByValue(value)
    self.flag = true
    if value ~= nil then
        local flag = true
        local v = nil
        for i,v in pairs(self.data_list)
        do
            if v == value then
                self:DeleteByKey(i)
                break
            end
        end
    end
end
function UIModel:Delete(key)
    print("想删除的物体是：" .. key)
    self:DeleteByValue(key)
end

function UIModel:Get()
    self.flag = false
    local temp_list = {}
    for i,v in pairs(self.data_list)
    do
        temp_list[i] = v
    end
    return temp_list
end

function UIModel:GetNotFlush()
    local temp_list = UIModel:Get()
    self.flag = true
    return temp_list
end

function UIModel:Clear()
    self.data_list = {}
    self.flag = true
end