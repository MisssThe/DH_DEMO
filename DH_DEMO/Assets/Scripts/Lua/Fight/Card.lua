require("framework.SharedTools")
-- 卡牌基类
Global.Card = {}
Card.__index = Card
function Card:New()
    local temp
    setmetatable(temp.Card)
    return temp
end

-- 逻辑层


-- 显示层