-- 管理卡牌战斗
-- 接收玩家指令并执行逻辑
-- 接收双方玩家操作并通过网络交互
require("Assets/Scripts/Lua/Fight/RoleAttribute.lua")
require("Assets/Scripts/Lua/Fight/CardsSystem.lua")

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
    EventSystem.Send(command,"Image")
    EventSystem.Send(command,"Scrollbar")
    EventSystem.Send(command,"InputField")
    EventSystem.Send(command,"talk1")
    EventSystem.Send(command,"talk2")
end
-- 双方约定战斗后调用
function FightSystem.StartFight(
    self_name,rivial_name,
    isFirst,
    p_max_hp,p_max_mp,p_max_sp,p_one_sp,p_ned_sp,p_card_num,
    r_max_hp,r_max_mp,r_max_sp,r_one_sp,r_ned_sp
)
    -- 初始化玩家基本信息
    FightSystem.player_info.self_name = self_name
    FightSystem.player_info.rivial_name = rivial_name
    -- 初始化人物属性
    FightSystem.Player_Attri = RoleAttribute:New(p_max_hp,p_max_mp,p_max_sp,p_one_sp,p_ned_sp)
    FightSystem.Rivial_Attri = RoleAttribute:New(r_max_hp,r_max_mp,r_max_sp,r_one_sp,r_ned_sp)
    -- 初始化卡牌系统
    local p_bag_card = EventSystem.Send("GetBagCard")
    FightSystem.card_system = CardsSystem:New(p_bag_card,p_card_num)
    -- 初始化round
    FightSystem.Round.round_num = 0
    FightSystem.Round.is_self = isFirst

    -- 初始化UI
    FightSystem.InitFightUI("OpenUI")
    if isFirst then
        FightSystem.StartRound()
    end
end

-- 某一方玩家使用卡牌时调用
function FightSystem.SendCard(card_name,to_self)
    if FightSystem.is_self == true then
        card_name = string.sub(card_name,1,string.find(card_name,"(Clone)",1,true) - 1)
        FightSystem.card_system:UseCardFromHand(card_name)
        if to_self then
            print("我方使用了卡牌" .. card_name)
            EventSystem.Send(card_name .. "_Effect",FightSystem.Player_Attri,FightSystem.Rivial_Attri)
            CS.NetWork.SendFight(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name,card_name)
        else
            print("对方使用了卡牌" .. card_name)
            EventSystem.Send(card_name .. "_Effect",FightSystem.Rivial_Attri,FightSystem.Player_Attri)
        end
        EventSystem.Send(card_name .. "_Display")
        return true
    end
    return false
end

-- 超时或玩家结束回合时调用
function FightSystem.EndRound()
    print("尝试结束回合")
    if FightSystem.Round.is_self == true then
        print("结束回合")
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
    -- 获取控制权
    FightSystem.Round.is_self = true
    -- 播放回合切换
    EventSystem.Send("ChangeRound")
    -- 更新卡牌系统
    FightSystem.card_system:GetCardFromBag()
end
function FightSystem.DrawCard(num)
    FightSystem.card_system:GetCardFromBag(num)
end
-- 因某种事件结束战斗时调用
function FightSystem.EndFight()
    -- 发送战斗结束请求
    -- CS.NetWork.SendEndFight(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name)
    FightSystem.Round.round_num = 0
    FightSystem.Rivial_Attri = nil
    FightSystem.Player_Attri = nil
    FightSystem.card_system = nil
    FightSystem.InitFightUI("CloseUI")
end

EventSystem.Add("StartFight",false,FightSystem.StartFight)
EventSystem.Add("SendCard",false,FightSystem.SendCard)
EventSystem.Add("EndRound",false,FightSystem.EndRound)
EventSystem.Add("StartRound",false,FightSystem.StartRound)
EventSystem.Add("EndFight",false,FightSystem.EndFight)
