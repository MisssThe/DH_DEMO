require("Assets/Scripts/Lua/EventSystem.lua")
-- 管理所有卡牌
Global.CardsControl = {}
CardsControl.cards_list = List:New()
CardsControl.cards_num = 6
---------------------------------------- 所有卡牌数据 ----------------------------------------
Global.card_0 = nil
-- Global.card_1
-- Global.card_2
-- Global.card_3
-- Global.card_4
-- Global.card_5
----------------------------------------------------------------------------------------------

-- 初始化control
function CardsControl:InitControl()
    local card_list = UE.GameObject.FindGameObjectsWithTag("Card")
    local length = card_list.Length - 1
    print("lenght" .. length)
    for i = 0,length,1 do
        self.cards_list:Add(card_list[i].name,card_list[i])
    end
end
CardsControl:InitControl()

-- 获取卡牌
function CardsControl:GetCard(card_name)
    return self.cards_list:Search(card_name)
end

-- EventSystem.Add("GetCard",false,CardsControl.GetCard)
-- EventSystem.Add("AddCard",false,CardsControl.AddCard)