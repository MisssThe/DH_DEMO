-- 用于背包系统的显示
require("Assets/Scripts/Lua/Fight/BagSystemModel.lua")
require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/UI/UIModel.lua")
local BagSystemView = {}
local main_view = nil
local open_view = nil
local close_view = nil
local bag_model = nil
Global.main_panel = nil
Global.open_button = nil
Global.close_button = nil
------------------------------------- 功能函数 -------------------------------------
function BagSystemView.EventFunc1()
    -- 退出当前背包
    EventSystem.Send("CloseUI","Close")
    EventSystem.Send("CloseUI","Base")
end
function BagSystemView.EventFunc2()
    -- 打开当前背包
    EventSystem.Send("OpenUI","Base")
    EventSystem.Send("OpenUI","Close")
end

local grid_list = List:New()
function BagSystemView:UpdateView()
    -- 读取model数据
    if BagSystemModel.flag then
        print("upday card bah")
        local card_list = UIModel:Get()
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

function BagSystemView:CreateGrid(name)
    local card = nil
    local grid = nil
    card = CardsControl:GetCard(name)
    grid = UE.Object.Instantiate(card)
    grid:SetParent(main_panel)
end
function BagSystemView:ClearGrid()
    while flag
    do
        value,flag = card_list:Iterator()
        -- self:CreateGrid(value)
        UE.Destroy(CardsControl:GetCard(value))
    end
end
------------------------------------- 生命周期 -------------------------------------
function Global.Awake()
    main_view = UIView:New(main_panel.gameObject)
    open_view = UIView:New(open_button.gameObject)
    close_view = UIView:New(close_button.gameObject)
    -- 获取背包数据
    local name_list = List:New()
    name_list:Add(1,"card_0")
    name_list:Add(2,"card_2")
    bag_model = UIModel:New(name_list)
    if main_view ~= nil and open_view ~= nil and close_view ~= nil then
        close = close_button.gameObject:GetComponent(typeof(UI.Button))
        if (close ~= nil) then
            close.onClick:AddListener(BagSystemView.EventFunc1)
        end
        open = open_button.gameObject:GetComponent(typeof(UI.Button))
        if open ~= nil then
            open.onClick:AddListener(BagSystemView.EventFunc2)
        end
    end
    -- 更新道具
    BagSystemView:UpdateView()
end

function Global.Update()
    BagSystemView.UpdateView()     
end