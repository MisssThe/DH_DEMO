-- -- require("framework.SharedTools")
-- -- 卡牌基类
-- -- Global.
-- Card = {}
-- Card.__index = Card
-- Card.type = nil
-- -- Global.card_type = {"ATTACK","MAGIC","SUBSIDIARY"}
-- -- card_type = CreateEnum(card_type)

-- --------------------------------- 基础功能 -------------------------------
-- function Card:New(type)
--     local temp = {}
--     setmetatable(temp,Card)
--     temp.type = type
--     return temp
-- end

-- -- 使用卡牌时产生的效果
-- function Card:UseCard()
--     print("use base card")
-- end

-- --------------------------------- 逻辑层 ---------------------------------
-- AttackCard = {}



-- --------------------------------- 显示层 ---------------------------------

Global.BaseCard = {}

BaseCard.type = nil

function BaseCard:New()
end
function BaseCard:Effect()
end
function BaseCard:Display()
end






-- 普通攻击

local normal_attack = BaseCard:New()

function normal_attack:Effect(p,r)
    local num = 10
    num = p:Attack(num)
    r:ReduceHP(num)
end

EventSystem.Add("normal_attack_effect",false,normal_attack:Effect)