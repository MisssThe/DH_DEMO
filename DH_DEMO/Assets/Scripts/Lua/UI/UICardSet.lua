require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/Fight/CardsControl.lua")
require("Assets/Scripts/Lua/Fight/FightSystem.lua")
-- require("framework.SharedTools.lua")

local cardset_view = nil
function Global.Awake()
    cardset_view = UIView:New(cs_self.gameObject)
end
local old_card_set = {}

function Global.Update()
    -- 监控战斗系统中的卡牌系统
    if FightSystem.card_system ~= nil then
        if FightSystem.card_system.flag then
            -- 更新卡牌显示
            local card_set = FightSystem.card_system:GetHandCard()
            local new_card_set = {}
            -- 将新卡牌集与旧卡牌集对比
            local exit = false
            for i,v in pairs(card_set)
            do
                -- 若卡牌存在，则设置到对应位置
                -- 若不存在则创建
                if old_card_set[v] ~= nil then
                    old_card_set[v]:SetSiblingIndex(i)
                    new_card_set[v] = old_card_set[v]
                else
                    local new_card = CreatCard(v)
                    old_card_set[v]:SetSiblingIndex(i)
                    new_card_set[v] = new_card
                end
            end
            old_card_set = new_card_set
        end
    end
end

local function CreatCard(card_name)
    local card = CardsControl:GetCard(card_name)
    local ins_card = UE.Object.Instantiate(t_card)
    ins_card.transform:SetParent(cs_self.transform)
    return ins_card
end