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
local interval_time = 300
local wait_time = 400
local is_open = true
Global.store_main_panel = nil
Global.store_open_button = nil
Global.store_close_button = nil
------------------------------------- 功能函数 -------------------------------------
local canvas = UE.GameObject.FindGameObjectsWithTag("Canvas")[0]
cs_self.gameObject.transform:SetParent(canvas.transform)
cs_self.transform.localPosition = UE.Vector3(0,0,0)
cs_self.transform.localScale = UE.Vector3(1,1,1)

function StoreSystemView.EventFunc1()
    -- 退出当前背包
    EventSystem.Send("CloseUI","StoreClose")
    EventSystem.Send("CloseUI","StoreBase")
    is_open = false
end
function StoreSystemView.EventFunc2()
    -- 打开当前背包
    print("打开背包")
    print(EventSystem.IsExit("OpenUI"))
    EventSystem.Send("OpenUI","StoreBase")
    EventSystem.Send("OpenUI","StoreClose")
    -- main_view:MoveTop(store_main_panel.transform.parent.gameObject)
    main_view:MoveTopSelf()
    is_open = true
end

local grid_list = List:New()
function StoreSystemView:EventFunc3()
    -- 购买卡牌
    local t_card = GetSelectObj()
    local card_name = t_card.name
    local length = #card_name
    card_name = string.sub(card_name,1,length - 7)
    -- 找到第一张name相同的卡牌
    store_model:DeleteByValue(card_name)
    EventSystem.Send("BuyCard",card_name)
end
function StoreSystemView:UpdateView()
   StoreSystemView:AddData()
   StoreSystemView:UpdateData()
end
function StoreSystemView:AddData()
     -- 固定间隔时间刷新商店,背包打开时刷新
    -- 打开后从卡池中随机获取三（暂定）张牌
    if (wait_time > interval_time) then
        if is_open == true then
            math.randomseed(os.time())
            store_model:Clear()
            local random_name = nil
            for i = 0,2,1 do
                random_name = "card_" .. math.random(0,6)
                store_model:Add(i,random_name)
            end
            wait_time = 0
        end
    else
        wait_time = wait_time + UE.Time.deltaTime
    end
end

function StoreSystemView:UpdateData()
    --  读取model数据
    if store_model.flag then
        local card_list = store_model:Get()
        if (card_list ~= nil) then
            StoreSystemView:ClearGrid()
            for i,v in pairs(card_list)
            do
                StoreSystemView:CreateGrid(v)
            end
        end    
    end
end

function StoreSystemView:CreateGrid(card_name)
    if card_name ~= nil then
        local t_card = nil
        local grid = nil
        t_card = EventSystem.Send("GetBaseCard",card_name)
        if t_card ~= nil then
            grid = UE.Object.Instantiate(t_card)
            --print(grid)
            if store_main_panel.transform ~= nil then
                --print(store_main_panel.name)
                -- grid.transform:SetParent(store_main_panel.transform)
                -- -- !!!!!!!!!!!!!!!!!!!!!!!!!!
                -- grid.transform.localScale = UE.Vector3(3,6,1)
                -- --print(grid.transform.localScale)
                -- -- 设置监听事件
                grid:GetComponent(typeof(UI.Button)).onClick:AddListener(StoreSystemView.EventFunc3)
            end
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
    store_model = UIModel:New()
    if main_view ~= nil and open_view ~= nil and close_view ~= nil then
        close = store_close_button.gameObject:GetComponent(typeof(UI.Button))
        if (close ~= nil) then
            close.onClick:AddListener(StoreSystemView.EventFunc1)
        end
        open = store_open_button.gameObject:GetComponent(typeof(UI.Button))
        UIManager.OpenUI(store_open_button.gameObject.name)
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