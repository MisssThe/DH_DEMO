require("Assets/Scripts/Lua/EventSystem.lua")

Global.UIModel = {}
UIModel.__index = UIModel
UIModel.data_list = List:New()
UIModel.flag = true

function UIModel:New(list)
    local temp = {}
    setmetatable(temp,UIModel)
    if list ~= nil then
        local temp_list = list:Copy()
        if temp_list ~= nil then
            self.data_list = temp_list
        end
        temp.flag = true
    end
    return temp
end

function UIModel:Add(data_name,data)
    if data_name ~= nil and data ~= nil then
        self.data_list:Add(data_name,data)
        self.flag = true
    end
end

function UIModel:Delete(key)
    print("ccccccccccccccc")
    if key ~= nil then
        -- self.data_list:Delete(key)
        self:Clear()
        print("clear")
        self.flag = true
    end
end

function UIModel:Get()
    self.flag = false
    local temp_list = self.data_list:Copy()
    return temp_list
end

function UIModel:Clear()
    self.data_list:Clear()
    self.flag = true
end