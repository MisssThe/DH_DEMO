-- 控制战斗中卡牌所属
-- 操作：每回合从背包抽牌，使用手牌，从随机池中取牌
require("framework.SharedTools")

Global.CardsSystem = {}
CardsSystem.__index = CardsSystem
CardsSystem.attri = {}
CardsSystem.card_pool = {}
CardsSystem.flag = true
--------------------------------------- 卡池 ---------------------------------------
CardsSystem.card_pool.bag_pool = nil
CardsSystem.card_pool.bag_pool_index = 0
CardsSystem.card_pool.hand_pool = nil
CardsSystem.card_pool.hand_pool_index = 0

--------------------------------------- 属性 ---------------------------------------
CardsSystem.attri.num = nil

---------------------------------------功能实现--------------------------------------- 
-- 实例化卡牌系统
function CardsSystem:New(bag_cards,num)
    local temp = {}
    setmetatable(temp,CardsSystem)
    temp.card_pool.bag_cards = bag_cards
    temp.card_pool.hand_pool = {}
    temp.attri.num = num
    return temp
end
-- 实现取牌功能（回合开始；特殊卡牌）
function CardsSystem:GetCardFromBag(card_num)
    if card_num == nil then
        card_num = self.attri.num
    end
    local temp_list = {}
    local index = 0
    for i,v in pairs(self.card_pool.bag_pool)
    do
        temp_list[index] = v
        self.card_pool.bag_pool[i] = nil
        index = index + 1
    end
    self.flag = true
    return temp_list
end
-- 实现用牌功能
function CardsSystem:UseCardFromHand(card_name)
    if card_name ~= nil then
        for i,v in pairs(self.card_pool.hand_pool)
        do
            if v == card_name then
                self.card_pool.hand_pool[i] = nil
                break
            end
        end
        self.flag = true
    end
end

function CardsSystem:UseCardFromBag()
end


-- 获取手牌
function CardsSystem:GetHandCard()
    local temp = {}
    local index = 0
    for i,v in pairs(self.card_pool.hand_pool)
    do
        temp[index] = v 
        index = index + 1
    end
    self.flag = false
    return temp
end