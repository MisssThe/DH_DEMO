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
BaseCard.gameObject = nil
BaseCard.__index = BaseCard
BaseCard.type = nil

function BaseCard:New(gameObject)
    local temp = {}
    setmetatable(temp,BaseCard)
    return temp
end
function BaseCard:Effect()
end
function BaseCard:Display()
end

---------------------------------------- 出牌效果实现 ----------------------------------------
function BaseCard:Use()
    -- 随着卡牌的拖动会慢慢消散

end
BaseCard.card_move = {}
BaseCard.card_move.old_pos = nil
BaseCard.card_move.move_speed = 0
function Global.OnBeginDrag(data)
    -- 开始拖拽时将card移除grid group
    -- print("")
    cs_self.transform:SetParent(UE.GameObject.FindGameObjectsWithTag("Canvas")[0].transform)
end
function Global.OnDrag(data)
    local move = (data.position - old_pos) * BaseCard.card_move.move_speed
    cs_self.transform.position = cs_self.transform.position + UE.Vector3(move.x,move.y,0)

    print(cs_self.transform.position)
end

function Global.OnEndDrag(data)
    -- 停止拖动时卡牌归为
end