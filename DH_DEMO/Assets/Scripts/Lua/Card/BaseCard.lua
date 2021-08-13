BaseCard = {["num"] = 0,["CardType"] = "none"}

BaseCard.__index = BaseCard

function BaseCard:new(num)
    local temp = {}
    temp.num = num
    temp.CardType = "none"
    setmetatable(temp,BaseCard)
    return temp
end

function BaseCard:use()
    
end

