-- 管理卡牌战斗
-- 接收玩家指令并执行逻辑
-- 接收双方玩家操作并通过网络交互
require("Assets/Scripts/Lua/Fight/RoleAttribute.lua")
require("Assets/Scripts/Lua/Fight/CardsSystem.lua")
require("Assets/Scripts/Lua/Fight/SkillEffect.lua")

Global.FightSystem = {}

FightSystem.Rivial_Attri = nil 
FightSystem.Player_Attri = nil
FightSystem.card_system = nil
FightSystem.Round = {}
FightSystem.Round.round_num = 0
FightSystem.Round.is_first = true
FightSystem.Round.is_self = true
FightSystem.player_info = {}
FightSystem.player_info.self_name = nil
FightSystem.player_info.rivial_name = nil
FightSystem.isFighting = false
FightSystem.Effect = {}
FightSystem.Effect.player_effect = nil
FightSystem.Effect.rivial_effect = nil

------------------------------------ 功能实现 ------------------------------------
function FightSystem.InitFightUI(command)
    EventSystem.Send(command,"player_rudder")
    EventSystem.Send(command,"rivial_rudder")
    EventSystem.Send(command,"PHP")
    EventSystem.Send(command,"PMP")
    EventSystem.Send(command,"PSP")
    EventSystem.Send(command,"RHP")
    EventSystem.Send(command,"RMP")
    EventSystem.Send(command,"RSP")
    EventSystem.Send(command,"CardSet")
    EventSystem.Send(command,"ChatImage")
    EventSystem.Send(command,"ChatButton")
    EventSystem.Send(command,"Scrollbar")
    EventSystem.Send(command,"InputField")
    EventSystem.Send(command,"talk1")
    EventSystem.Send(command,"talk2")
    EventSystem.Send(command,"ExitButton")
    local fight_sence = UE.GameObject.FindGameObjectsWithTag("FightSence")[0]
    local sence_rect = fight_sence:GetComponent(typeof(UE.RectTransform))
    sence_rect:SetInsetAndSizeFromParentEdge(UE.RectTransform.Edge.Left, 0, 0)
    sence_rect:SetInsetAndSizeFromParentEdge(UE.RectTransform.Edge.Top, 0, 0)
    sence_rect.anchorMin = UE.Vector2(0,0)
    sence_rect.anchorMax = UE.Vector2(1,1)
end
-- 双方约定战斗后调用
function FightSystem.StartFight(
    self_name,rivial_name,
    isFirst,
    p_max_hp,p_max_mp,p_max_sp,p_one_sp,p_ned_sp,p_card_num,
    r_max_hp,r_max_mp,r_max_sp,r_one_sp,r_ned_sp
)
    -- 置为战斗中状态
    FightSystem.isFighting = true
    -- 初始化玩家基本信息
    FightSystem.player_info.self_name = self_name
    FightSystem.player_info.rivial_name = rivial_name
    -- 初始化人物属性
    FightSystem.Player_Attri = RoleAttribute:New(p_max_hp,p_max_mp,p_max_sp,p_one_sp,p_ned_sp,self_name)
    FightSystem.Rivial_Attri = RoleAttribute:New(r_max_hp,r_max_mp,r_max_sp,r_one_sp,r_ned_sp,rivial_name)
    -- 初始化卡牌系统
    local p_bag_card = EventSystem.Send("GetBagCard")
    FightSystem.card_system = CardsSystem:New(p_bag_card,p_card_num)
    -- 初始化round
    FightSystem.Round.round_num = 0
    FightSystem.Round.is_self = isFirst

    if FightSystem.Effect.player_effect == nil then
        FightSystem.Effect.player_effect = SkillEffect:New(self_name)
    end
    FightSystem.Effect.rivial_effect = SkillEffect:New(rivial_name)
    -- 初始化UI
    FightSystem.InitFightUI("OpenUI")
    if isFirst then
        FightSystem.StartRound()
    end
    EventSystem.Send("PlayFightStart")
end

-- 某一方玩家使用卡牌时调用
function FightSystem.SendCard(card_name,to_self)
    print("进入sendcard")
    if card_name ~= nil then
        FightSystem.card_system:UseCardFromHand(card_name)
        if to_self then
            if FightSystem.Round.is_self == true then
                EventSystem.Send("PlaySendCard")
                card_name = string.sub(card_name,1,string.find(card_name,"(Clone)",1,true) - 1)
                EventSystem.Send(card_name .. "_Effect",FightSystem.Player_Attri,FightSystem.Rivial_Attri)
                CS.NetWork.SendFight(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name,card_name)
            end
        else
            if FightSystem.Round.is_self ~= true then
                EventSystem.Send(card_name .. "_Effect",FightSystem.Rivial_Attri,FightSystem.Player_Attri)
            end
        end
        EventSystem.Send(card_name .. "_Display")
        return true
    else
        return false
    end
    return false
end

-- 超时或玩家结束回合时调用
function FightSystem.EndRound()
    print("尝试结束回合")
    if FightSystem.Round.is_self == true then
        print("结束回合")
        -- 播放结束音乐
        EventSystem.Send("PlayFightTurnRound")
        FightSystem.Round.round_num = FightSystem.Round.round_num + 0.5
        -- 把控制权移交给对手
        FightSystem.Round.is_self = false
        -- 发送控制切换请求
        CS.NetWork.SendTurnEnd(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name)
    end
end

-- 轮到自己回合,接收到转换请求时回调
function FightSystem.StartRound()
    print("start round")
    EventSystem.Send("PlayFightTurnRound")
    -- 获取控制权
    FightSystem.Round.is_self = true
    -- 播放回合切换
    EventSystem.Send("ChangeRound")
    -- 更新卡牌系统
    FightSystem.card_system:GetCardFromBag()
    -- 判断是否进入疲劳状态
    if FightSystem.card_system.flag3 == true then
        FightSystem.Player_Attri:ReduceHP(round_num + 3,true)
    end
end
function FightSystem.DrawCard(num)
    FightSystem.card_system:GetCardFromBag(num)
end
-- 因某种事件结束战斗时调用
function FightSystem.EndFight(flag)
    -- 发送战斗结束请求
    -- CS.NetWork.SendEndFight(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name)
    if flag == false then
        -- CS.NetWork.SendMyLose(FightSystem.player_info.self_name, FightSystem.player_info.rivial_name)
        EventSystem.Send("PlayFightEndFailed")
    else
        EventSystem.Send("PlayFightEndSuccess")
    end
    EventSystem.Send("ShowEndFight",flag)
end

function FightSystem.RealEndFight()
    FightSystem.isFighting = false
    FightSystem.Round.round_num = 0
    FightSystem.Rivial_Attri = nil
    FightSystem.Player_Attri = nil
    FightSystem.card_system = nil
    FightSystem.InitFightUI("CloseUI")
    EventSystem.Send("ClearCardSet")
end

EventSystem.Add("StartFight",false,FightSystem.StartFight)
EventSystem.Add("SendCard",false,FightSystem.SendCard)
EventSystem.Add("EndRound",false,FightSystem.EndRound)
EventSystem.Add("StartRound",false,FightSystem.StartRound)
EventSystem.Add("EndFight",false,FightSystem.EndFight)
EventSystem.Add("RealEndFight",false,FightSystem.RealEndFight)