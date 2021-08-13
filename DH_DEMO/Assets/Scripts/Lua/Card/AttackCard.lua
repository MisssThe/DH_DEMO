require ('BaseCard')

AttackCard = {}
setmetatable(AttackCard,BaseCard)
AttackCard.__index = AttackCard

function AttackCard:new(num)
    local temp = BaseCard:new(num)
    setmetatable(temp,AttackCard)
    temp.CardType = "Attack"
    return temp
end

