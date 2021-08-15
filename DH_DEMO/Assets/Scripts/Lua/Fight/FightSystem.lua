-- 管理卡牌战斗
-- 接收玩家指令并执行逻辑
-- 接收双方玩家操作并通过网络交互
require("Assets/Scripts/Lua/Fight/RoleAttribute.lua")
require("Assets/Scripts/Lua/Fight/CardsSystem.lua")
Global.FightSystem = {}

FightSystem.Rivial_Attri = nil 
-- RoleAttribute:New(10,10,10,10,1)
FightSystem.Player_Attri = nil
-- RoleAttribute:New(10,10,10,10,1)
FightSystem.card_system = nil
-- CardsSystem:New({},1)
FightSystem.Round = {}
FightSystem.Round.round_num = 0
FightSystem.Round.is_first = true
FightSystem.Round.is_self = true

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
end
-- 双方约定战斗后调用
function FightSystem.StartFight(
    isFirst,
    p_max_hp,p_max_mp,p_max_sp,p_one_sp,p_ned_sp,p_card_num,
    r_max_hp,r_max_mp,r_max_sp,r_one_sp,r_ned_sp
)
    -- 初始化人物属性
    FightSystem.Player_Attri = RoleAttribute:New(p_max_hp,p_max_mp,p_max_sp,p_one_sp,p_ned_sp)
    FightSystem.Rivial_Attri = RoleAttribute:New(r_max_hp,r_max_mp,r_max_sp,r_one_sp,r_ned_sp)
    -- 初始化卡牌系统
    local p_bag_card = EventSystem.Send("GetBagCard")
    FightSystem.card_system = CardsSystem:New(p_bag_card,p_card_num)
    -- 初始化round
    FightSystem.Round.round_num = 0
    FightSystem.Round.is_first = isFirst
    FightSystem.Round.is_self = isFirst
    -- 初始化UI
    FightSystem.InitFightUI("OpenUI")
end

-- 某一方玩家使用卡牌时调用
function FightSystem.SendCard(card_name,to_self)
    if FightSystem.is_self == true then
        self.card_system:UseCardFromHand(card_name)
        if to_self then
            EventSystem.Send(card_name .. "_Effect",self.Player_Attri,self.Rivial_Attri)
        else
            EventSystem.Send(card_name .. "_Effect",self.Rivial_Attri,self.Player_Attri)
        end
        EventSystem.Send(card_name .. "_Display")
        return true
    end
    return false
end

-- 超时或玩家结束回合时调用
function FightSystem:EndRound()
    if self.is_self == true then
        self.Round.round_num = self.Round.round_num + 0.5
        -- 把控制权移交给对手
        self.is_self = false
        -- 发送控制切换请求
        -- Net
    end
end

-- 轮到自己回合,接收到转换请求时回调
function FightSystem:StartRound()
    -- 获取控制权
    self.is_self = true
    -- 更新卡牌系统
    self.card_system:GetCardFromBag()
end

-- 因某种事件结束战斗时调用
function FightSystem:EndFight()
    FightSystem.Round.round_num = 0
    FightSystem.Rivial_Attri = nil
    FightSystem.Player_Attri = nil
    FightSystem.card_system = nil
    FightSystem.InitFightUI("CloseUI")
end

return FightSystem