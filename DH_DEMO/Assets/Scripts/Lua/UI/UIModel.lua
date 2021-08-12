require("Assets/Scripts/Lua/EventSystem.lua")

Global.UIModel = {}
UIModel.__index = UIModel
UIModel.data_list = {}
UIModel.flag = true

function UIModel:New()
    local temp = {}
    setmetatable(temp,UIModel)
    return temp
end

function UIModel:Add(data_name,data)
    if data_name ~= nil and data ~= nil then
        self.data_list[data_name] = data
        self.flag = true
    end
end

function UIModel:Delete(key)
    self:DeleteByKey(key)
end
function UIModel:DeleteByKey(key)
    if key ~= nil then
        self.data_list[key] = nil
        self.flag = true
    end
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

function UIModel:Get()
    self.flag = false
    local temp_list = {}
    for i,v in pairs(self.data_list)
    do
        temp_list[i] = v
    end
    return temp_list
end

function UIModel:Clear()
    self.data_list = {}
    self.flag = true
end