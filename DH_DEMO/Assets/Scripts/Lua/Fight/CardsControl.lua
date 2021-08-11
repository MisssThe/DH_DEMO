require("Assets/Scripts/Lua/EventSystem.lua")
-- 管理所有卡牌
Global.CardsControl = {}
CardsControl.cards_list = List:New()
CardsControl.cards_num = 20
-- 所有卡牌
function CardsControl.AddAllCards()
    local index = 0
    while index < CardsControl.car
    do
        index = index + 1
        ASS.InstantiateAsync("card" .. index)
    end
end
function CardsControl.AddCard(card)
    if CardsControl.cards_list ~= nil then
        CardsControl.cards_list.Add(card.card_name,card)
    end
end

function CardsControl.GetCard(card_name)
    card = CardsControl.cards_list.Search(card_name)
    -- CardsControl.cards_list.Delete(card_name)
    return card
end

EventSystem.Add("GetCard",false,CardsControl.GetCard)
EventSystem.Add("AddCard",false,CardsControl.AddCard)