-- require("Assets/Scripts/Lua/UI/UIView.lua")
-- require("Assets/Scripts/Lua/Fight/CardsControl.lua")
-- require("Assets/Scripts/Lua/Fight/FightSystem.lua")

local cardset_view = {}
local cardset_list = {}
function Global.Awake()
    cardset_view = UIView:New(cs_self.gameObject)
end
local function CreatCard(card_name)
    local t_card = EventSystem.Send("GetBaseCard",card_name)
    print(t_card == nil)
    if t_card ~= nil then
        local i_card = UE.Object.Instantiate(t_card)
        if i_card ~= nil then
            i_card.transform:SetParent(cs_self.transform)
            i_card.transform.localScale = UE.Vector3(1.5,2.5,1)
            table.insert(cardset_list,i_card)
        end
        --cardset_view.cardset_list[cardset_view.list_index] = i_card
        --cardset_view.list_index = cardset_view.list_index + 1
    end
end
-- local function DeleteTable(index)
--     local temp_name = old_card_name_set[index]
--     local temp_obj = old_card_set[index]
--     old_card_temp_set[temp_name] = temp_obj
--     for i = index,hand_card_num,1 
--     do
--         old_card_name_set[i] = old_card_name_set[i + 1]
--         old_card_set[i] = old_card_set[i + 1]
--     end
-- end

function Global.Update()
    -- 监控战斗系统中的卡牌系统
    if FightSystem.card_system ~= nil then
        if FightSystem.card_system.flag2 then
            -- 更新卡牌显示
            print("更新卡牌显示")
            local card_set = FightSystem.card_system:GetNewCard()
            for i,v in pairs(card_set) do
                CreatCard(v)
                print("创建卡牌")
            end

            -- 将新卡牌集与旧卡牌集对比
            -- local exit = false
            -- local temp_card_set = {}
            -- local now_hand_num = hand_card_num
            -- for i,v in pairs(card_set)
            -- do
            --     local temp_i = i
            --     if i < now_hand_num then
            --         while old_card_name_set[i] ~= v
            --         do
            --             DeleteTable(temp_i)
            --             temp_i = temp_i + 1
            --             now_hand_num = now_hand_num - 1
            --         end
            --     else
            --         -- 判断弃牌库有无
            --         if old_card_temp_set[v] ~= nil then
            --             old_card_set[i] = old_card_temp_set
            --             old_card_temp_set[v] = nil
            --         else
            --             old_card_set[i] = CreatCard(i,v)
            --         end
            --     end
            -- end
        end
    end
end

function cardset_view.Clear()
    local child_cards = cs_self.gameObject:GetComponentsInChildren(typeof(UE.Transform))
    local child_length = child_cards.Length - 1
    for i = 1,child_length,1 do
        UE.GameObject.Destroy(child_cards[i].gameObject)
        print(child_cards[i].name)
    end
end

EventSystem.Add("ClearCardSet",false,cardset_view.Clear)