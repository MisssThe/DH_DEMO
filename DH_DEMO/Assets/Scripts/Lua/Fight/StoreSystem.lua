-- 用于商店系统的显示
-- 打开商店时随机获取几张牌
require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/UI/UIModel")
require("Assets/Scripts/Lua/Fight/CardsControl.lua")
local main_view = nil
local open_view = nil
local close_view = nil
local store_model = nil
local StoreSystemView = {}
StoreSystemView.is_close = true;
Global.store_main_panel = nil
Global.store_open_button = nil
Global.store_close_button = nil
------------------------------------- 功能函数 -------------------------------------
function StoreSystemView.EventFunc1()
    -- 退出当前背包
    if StoreSystemView.is_close ~= true then
        EventSystem.Send("CloseUI","StoreClose")
        EventSystem.Send("CloseUI","StoreBase")
    end
    StoreSystemView.is_close = true
end
function StoreSystemView.EventFunc2()
    -- 打开当前背包
    if StoreSystemView.is_close == true then
        EventSystem.Send("OpenUI","StoreBase")
        EventSystem.Send("OpenUI","StoreClose")
        main_view:MoveTop(store_main_panel.transform.parent.gameObject)
        -- 打开后从卡池中随机获取三（暂定）张牌
        math.randomseed(os.time())
        print(store_model.flag)

        store_model:Clear()
        local random_name = nil
        for i = 0,2,1 do
            random_name = "card_" .. math.random(0,CardsControl.cards_num)
            store_model:Add(i,random_name)
        end
    end
    StoreSystemView.is_close = false
end

local grid_list = List:New()
function StoreSystemView:EventFunc3()
    -- 购买卡牌
    local t_card = GetSelectObj()
    local card_name = t_card.name
    store_model.Delete(card_name)
end
function StoreSystemView:UpdateView()
    -- 读取model数据
    if store_model.flag then
        local card_list = store_model:Get()
        self:ClearGrid()
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

function StoreSystemView:CreateGrid(card_name)
    if card_name ~= nil then
        local t_card = nil
        local grid = nil
        t_card = CardsControl:GetCard(card_name)
        if t_card ~= nil then
            grid = UE.Object.Instantiate(t_card)
            grid.transform:SetParent(store_main_panel.transform)
            grid.transform.localScale = UE.Vector3(3,6,1)
        end
    end
end

function StoreSystemView:ClearGrid()
    local obj_list = store_main_panel:GetComponentsInChildren(typeof(UE.Transform))
    local length = obj_list.Length - 1
    for i = 1,length,1 
    do
        UE.Object.Destroy(obj_list[i].gameObject)
    end
end
------------------------------------- 生命周期 -------------------------------------
function Global.Awake()
    main_view = UIView:New(store_main_panel.gameObject)
    open_view = UIView:New(store_open_button.gameObject)
    close_view = UIView:New(store_close_button.gameObject)
    store_model = UIModel:New(nil)
    if main_view ~= nil and open_view ~= nil and close_view ~= nil then
        close = store_close_button.gameObject:GetComponent(typeof(UI.Button))
        if (close ~= nil) then
            close.onClick:AddListener(StoreSystemView.EventFunc1)
        end
        open = store_open_button.gameObject:GetComponent(typeof(UI.Button))
        if open ~= nil then
            open.onClick:AddListener(StoreSystemView.EventFunc2)
        end
    end
    -- 更新道具
    StoreSystemView:UpdateView()
end

function Global.Update()
    StoreSystemView:UpdateView()     
end