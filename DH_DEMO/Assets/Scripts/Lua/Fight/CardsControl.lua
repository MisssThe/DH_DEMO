require("Assets/Scripts/Lua/EventSystem.lua")
-- 管理所有卡牌
Global.CardsControl = {}
CardsControl.cards_list = {}
CardsControl.cards_num = 5
-- CardsControl.__index = CardsControl
---------------------------------------- 所有卡牌数据 ----------------------------------------

----------------------------------------------------------------------------------------------

-- 初始化control
function CardsControl.InitControl()
    local my_card_list = UE.GameObject.FindGameObjectsWithTag("Card")
    CardsControl.card_list = {}
    CardsControl.cards_num = my_card_list.Length - 1
    for i = 0,CardsControl.cards_num,1 do
        CardsControl.cards_list[my_card_list[i].gameObject.name] = my_card_list[i]
    end
end
CardsControl.InitControl()

-- for i,v in pairs(CardsControl.cards_list) do
--     print("key:" .. i)
-- end
-- 获取卡牌
function CardsControl.GetCard(card_name)
    local card = CardsControl.cards_list[card_name]
    return card
end

-- 获取一张随机卡牌
function CardsControl.GetRandomCard()
    math.randomseed(os.time())
    local num = math.random(0,CardsControl.cards_num)
    local ind = 1
    local t_card = nil
    for i,v in pairs(CardsControl.cards_list) do
        if ind > num then
            return v
        end
        ind = ind + 1
    end
end
math.randomseed(os.time())

function CardsControl.GetRandomCardName()
    local num = math.random(0,CardsControl.cards_num)
    local ind = 1
    local t_card = nil
    for i,v in pairs(CardsControl.cards_list) do
        if ind > num then
            return i
        end
        ind = ind + 1
    end
end

EventSystem.Add("GetBaseCard",false,CardsControl.GetCard)