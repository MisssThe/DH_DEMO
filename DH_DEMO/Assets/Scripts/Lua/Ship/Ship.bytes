Ship = {["name"] = 'none',["money"] = 0,["position_x"] = 0,["position_z"] = 0}

Ship.__index = Ship

function Ship:new(name,money,position_x,position_z)
    local temp_obj = {}
    temp_obj.name = name
    temp_obj.money = money
    temp_obj.position_x = position_x
    temp_obj.position_z = position_z
    setmetatable(temp_obj,Ship)
    return temp_obj
end

function Ship:GetName()
    return self.name
end

function Ship:SetName(name)
    self.name = name
end

function Ship:GetMoney()
    return self.money
end

function Ship:SetMoney(money)
    self.money = self.money + money
end

function Ship:GetPosition()
    return self.position_x,self.position_z
end

function Ship:SetPosition(position_x,position_z)
    self.position_x = position_x
    self.position_z = position_z
end

