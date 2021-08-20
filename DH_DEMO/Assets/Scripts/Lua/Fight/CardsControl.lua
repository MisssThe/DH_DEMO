require("Assets/Scripts/Lua/EventSystem.lua")
-- 管理所有卡牌
Global.CardsControl = {}
CardsControl.cards_list = {}
CardsControl.cards_num = 5
CardsControl.__index = CardsControl
---------------------------------------- 所有卡牌数据 ----------------------------------------

-- Global.card_5
----------------------------------------------------------------------------------------------

-- 初始化control
function CardsControl.InitControl()
    local my_card_list = UE.GameObject.FindGameObjectsWithTag("Card")
    CardsControl.cards_num = my_card_list.Length - 1
    for i = 0,CardsControl.cards_num,1 do
        CardsControl.cards_list[my_card_list[i].name] = my_card_list[i]
    end
end
CardsControl.InitControl()

-- 获取卡牌
function CardsControl.GetCard(card_name)
    local card = CardsControl.cards_list[card_name]
    return card
end


EventSystem.Add("GetBaseCard",false,CardsControl.GetCard)