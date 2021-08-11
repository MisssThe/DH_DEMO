-- require("framework.SharedTools")
-- 卡牌基类
-- Global.
Card = {}
Card.__index = Card
Card.type = nil
-- Global.card_type = {"ATTACK","MAGIC","SUBSIDIARY"}
-- card_type = CreateEnum(card_type)

--------------------------------- 基础功能 -------------------------------
function Card:New(type)
    local temp = {}
    setmetatable(temp,Card)
    temp.type = type
    return temp
end

-- 使用卡牌时产生的效果
function Card:UseCard()
    print("use base card")
end

--------------------------------- 逻辑层 ---------------------------------
AttackCard = {}



--------------------------------- 显示层 ---------------------------------