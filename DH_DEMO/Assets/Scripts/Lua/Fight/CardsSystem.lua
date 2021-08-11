-- 控制战斗中卡牌所属
-- 操作：每回合从背包抽牌，使用手牌，从随机池中取牌
require("framework.SharedTools")

Global.CardsSystem = {}
CardsSystem.__index = CardsSystem
--------------------------------------- 卡池 ---------------------------------------
CardsSystem.cards_pool = {}
-- 背包中
CardsSystem.cards_pool.bag_cards = Array:New()
CardsSystem.cards_pool.bag_cards_num = 0
-- 手牌
CardsSystem.cards_pool.hand_cards = Array:New()
CardsSystem.cards_pool.hand_cards_num = 0
-- 随机卡牌池
CardsSystem.cards_pool.random_cards = Array:New()
CardsSystem.cards_pool.random_cards_num = 0
-- 弃牌堆
CardsSystem.cards_pool.throw_cards = Array:New()
CardsSystem.cards_pool.throw_cards_num = 0
--------------------------------------- 属性 ---------------------------------------
CardsSystem.cards_attri = {}
-- 抽牌数
CardsSystem.cards_attri.num = 0
-- 随机度
CardsSystem.cards_attri.random = 0

-- 初始化卡牌系统
function CardsSystem:New(base_cards,num,random)
    local temp
    setmetatable(temp,CardsSystem)
    temp.cards_pool.bag_cards = base_cards
    temp.cards_attri.num = num
    temp.cards_attri.random = random
    return temp
end

-- 从背包取牌
function CardsSystem:GetCardFromBag()
    local index = 0
    local card
    for i = 0,self.cards_attri.num,1 
    do
        index = math.random(0,self.cards_attri.random)
        if index > self.cards_pool.bag_cards.count then
            index = self.cards_pool.bag_cards.count
        end
        card = self.cards_pool.bag_cards.Get(index)
        self.cards_pool.hand_cards.Add(card)
        self.cards_pool.bag_cards.Delete(index)
    end
end

-- 使用手牌
function CardsSystem:UseCardFromHand(index)
    local card = self.cards_pool.hand_cards.Get(index)
    self.cards_pool.throw_cards.Add(card)
    self.cards_pool.hand_cards.Delete(index)
end












-- -- 向手牌堆添加牌
-- function CardsSystem:AddCardIntoHand(card)
--     if self.cards_pool.hand_cards ~= nil then
--         self.cards_pool.hand_cards
--     end
-- end
-- -- 向弃牌堆添加牌
-- function CardsSystem:AddCardInto()
-- end