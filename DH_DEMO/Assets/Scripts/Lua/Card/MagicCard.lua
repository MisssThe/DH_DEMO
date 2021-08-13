require ("BaseCard")

MagicCard = {["cost"] = 0}
setmetatable(MagicCard,BaseCard)
MagicCard.__index = MagicCard

function MagicCard:new(num,cost)
    local temp = BaseCard:new(num)
    setmetatable(temp,MagicCard)
    temp.CardType = "MagicCard"
    temp.cost = cost
    return temp;
end

