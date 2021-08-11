-- 用于控制背包逻辑数据
require("Assets/Scripts/Lua/UI/UIModel.lua")
Global.BagSystemModel = {}
BagSystemModel.__index = BagSystemModel
BagSystemModel.card_list = List:New()
BagSystemModel.flag = false

-- 初始化卡牌
function BagSystemModel:InitCard(cards_list)
    -- 去card_control中获取对于卡牌
    local card = nil
    -- for i,name inpairs(cards_list)
    -- do
    --     if name ~= nil then
    --         card = CardsControl.GetCard(name)
    --         self:AddCard(name,card)
    --     end
    -- end
    self.flag = true
end

-- 添加卡牌
function BagSystemModel:AddCard(card_name,card)
    if card_name ~= nil and card ~= nil then
        self.card_list:Add(card_name,card)
        self.flag = true
    end
end

-- 删除卡牌
function BagSystemModel:DeleteCard(card_name)
    if card_name ~= nil then
        self.card_list:Delete(card_name)
        self.flag = true
    end
end

-- 获取现有卡牌
function BagSystemModel:GetCards()

end

-- 实例化model
function BagSystemModel:New()
    local temp = {}
    setmetatable(temp,BagSystemModel)
    return temp
end