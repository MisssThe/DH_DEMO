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
local BuyVoice = {}
BuyVoice.source = nil
BuyVoice.success = nil
BuyVoice.failed = nil
BuyVoice.voice_flag = true
------------------------------------- 功能函数 -------------------------------------
local canvas = UE.GameObject.FindGameObjectsWithTag("Canvas")[0]
cs_self.gameObject.transform:SetParent(canvas.transform)
cs_self.transform.localPosition = UE.Vector3(0,0,0)
cs_self.transform.localScale = UE.Vector3(1,1,1)

function BagSystemView.EventFunc1()
    -- 退出当前背包
    EventSystem.Send("CloseUI","BagClose")
    EventSystem.Send("CloseUI","BagBase")
end
function BagSystemView.EventFunc2()
    -- 打开当前背包
    EventSystem.Send("OpenUI","BagBase")
    EventSystem.Send("OpenUI","BagClose")
    main_view:MoveTopSelf()
end

local grid_list = List:New()
function BagSystemView.EventFunc3()
    -- 出售卡牌
    -- 删除卡牌并增加金币
    local t_card = GetSelectObj()
    local card_name = t_card.name
    bag_model.Delete(card_name)
end
local card_index = 0

function BagSystemView.EventFunc4(card_name)
    -- 购买卡牌并减少金币
    if bag_model:Add(card_index,card_name) then
        -- 播放购买成功音效
        BuyVoice.source.clip = BuyVoice.success
        source.Play()
    else
        -- 播放购买失败音效
        BuyVoice.source.clip = BuyVoice.failed
        source.Play()
    end
    card_index = card_index + 1
end
EventSystem.Add("BuyCard",false,BagSystemView.EventFunc4)

function BagSystemView.EventFunc5()
    -- 获取当前背包所有卡牌
    local bag_card_set = bag_model:GetNotFlush()
    return bag_card_set
end
EventSystem.Add("GetBagCard",false,BagSystemView.EventFunc5)

function BagSystemView:UpdateView()
    -- 读取model数据
    if bag_model.flag then
        local card_list = bag_model:Get()
        self.ClearGrid()
        for i,v in pairs(card_list)
        do
            BagSystemView:CreateGrid(v)
        end
    end
end

function BagSystemView:CreateGrid(card_name)
    if card_name ~= nil then
        local t_card = nil
        local grid = nil
        t_card = EventSystem.Send("GetBaseCard",card_name)
        -- CardsControl:GetCard(card_name)
        if t_card ~= nil then
            grid = UE.Object.Instantiate(t_card)
            grid.transform:SetParent(bag_main_panel.transform)
            grid.transform.localScale = UE.Vector3(1.6,2,1)
            -- 设置监听事件
            grid:GetComponent(typeof(UI.Button)).onClick:AddListener(BagSystemView.EventFunc3)
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
local canvas = UE.GameObject.FindGameObjectsWithTag("Canvas")[0]
cs_self.gameObject.transform:SetParent(canvas.transform)
cs_self.transform.localPosition = UE.Vector3(0,0,0)
cs_self.transform.localScale = UE.Vector3(1,1,1)

function Global.Awake()
    -- 填充音效
    BuyVoice.source = cs_self.gameObject:GetComponent(typeof(UE.AudioSource))
    if BuyVoice.source ~= nil then
        BuyVoice.source.loop = false
        BuyVoice.source.playOnAwake = false
        --BuyVoice.success = ExAAS.LoadAudioSync("Assets/ExternalResources/Voice/孤单抢手2音效-购买(buy)_爱给网_aigei_com.mp3")
        --BuyVoice.failed = ExAAS.LoadAudioSync("Assets/ExternalResources/Voice/孤单抢手2音效-购买(buy)_爱给网_aigei_com.mp3")
    end
    main_view = UIView:New(bag_main_panel.gameObject)
    open_view = UIView:New(bag_open_button.gameObject)
    close_view = UIView:New(bag_close_button.gameObject)
    bag_model = UIModel:New()
    -- 获取背包数据
    local bag_card_list = {"Normal1","Normal1","Normal2","Normal3","Normal5","Normal3","Normal2","Normal2","Normal3","Normal5","Normal3","Normal2","Normal2","Normal3","Normal5","Normal3","Normal2"}
    for i,v in pairs(bag_card_list) do
        bag_model:Add(i,v)
    end
    if main_view ~= nil and open_view ~= nil and close_view ~= nil then
        close = bag_close_button.gameObject:GetComponent(typeof(UI.Button))
        if (close ~= nil) then
            close.onClick:AddListener(BagSystemView.EventFunc1)
        end
        open = bag_open_button.gameObject:GetComponent(typeof(UI.Button))
        UIManager.OpenUI(bag_open_button.gameObject.name)
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