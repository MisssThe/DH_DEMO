require ("BaseCard")

BuffCard = {["BuffTo"] = "none"}
setmetatable(BuffCard,BaseCard)
BuffCard.__index = BuffCard

function BuffCard:new(num,BuffTo)
    local temp = BaseCard:new(num)
    setmetatable(temp,BuffCard)
    temp.CardType = "BuffCard"
    temp.BuffTo = BuffTo
    return temp;
end

