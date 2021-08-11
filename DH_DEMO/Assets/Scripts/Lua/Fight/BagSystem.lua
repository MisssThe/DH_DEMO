-- 用于背包系统的显示
require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/UI/UIModel.lua")
require("Assets/Scripts/Lua/Fight/CardsControl.lua")
local main_view = nil
local open_view = nil
local close_view = nil
local bag_model = nil
local BagSystemView = {}
Global.bag_main_panel = nil
Global.bag_open_button = nil
Global.bag_close_button = nil
------------------------------------- 功能函数 -------------------------------------
function BagSystemView.EventFunc1()
    -- 退出当前背包
    EventSystem.Send("CloseUI","BagClose")
    EventSystem.Send("CloseUI","BagBase")
end
function BagSystemView.EventFunc2()
    -- 打开当前背包
    EventSystem.Send("OpenUI","BagBase")
    EventSystem.Send("OpenUI","BagClose")
    main_view:MoveTop(bag_main_panel.transform.parent.gameObject)
end

local grid_list = List:New()
function BagSystemView:EventFunc3()
    -- 出售卡牌
    local t_card = GetSelectObj()
    local card_name = t_card.name
    bag_model.Delete(card_name)
end

function BagSystemView:UpdateView()
    -- 读取model数据
    if bag_model.flag then
        local card_list = bag_model:Get()
        self.ClearGrid()
        card_list:InitIter()
        local flag = true
        local value = nil
        while flag
        do
            value,flag = card_list:Iterator()
            self:CreateGrid(value)
        end
    end
end

function BagSystemView:CreateGrid(card_name)
    if card_name ~= nil then
        local t_card = nil
        local grid = nil
        t_card = CardsControl:GetCard(card_name)
        if t_card ~= nil then
            grid = UE.Object.Instantiate(t_card)
            grid.transform:SetParent(bag_main_panel.transform)
        end
    end
end

function BagSystemView:ClearGrid()
    local obj_list = bag_main_panel:GetComponentsInChildren(typeof(UE.Transform))
    local length = obj_list.Length - 1
    for i = 1,length,1 
    do
        UE.Object.Destroy(obj_list[i].gameObject)
    end
end
------------------------------------- 生命周期 -------------------------------------
function Global.Awake()
    main_view = UIView:New(bag_main_panel.gameObject)
    open_view = UIView:New(bag_open_button.gameObject)
    close_view = UIView:New(bag_close_button.gameObject)
    -- 获取背包数据
    local name_list = List:New()
    name_list:Add(1,"card_0")
    name_list:Add(2,"card_2")
    bag_model = UIModel:New(name_list)
    if main_view ~= nil and open_view ~= nil and close_view ~= nil then
        close = bag_close_button.gameObject:GetComponent(typeof(UI.Button))
        if (close ~= nil) then
            close.onClick:AddListener(BagSystemView.EventFunc1)
        end
        open = bag_open_button.gameObject:GetComponent(typeof(UI.Button))
        if open ~= nil then
            open.onClick:AddListener(BagSystemView.EventFunc2)
        end
    end
    -- 更新道具
    BagSystemView:UpdateView()
end

function Global.Update()
    BagSystemView:UpdateView()     
end