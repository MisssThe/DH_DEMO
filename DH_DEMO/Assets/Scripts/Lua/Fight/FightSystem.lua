-- 管理卡牌战斗
-- 接收玩家指令并执行逻辑
-- 接收双方玩家操作并通过网络交互
require("Assets/Scripts/Lua/EventSystem.lua")
require("Assets/Scripts/Lua/Fight/RoleAttribute.lua")
Global.FightSystem = {}

FightSystem.Rivial_Attri = RoleAttribute:New(10,10,10,10,1)
FightSystem.Player_Attri = RoleAttribute:New(10,10,10,10,1)
FightSystem.card_system = CardsSystem:New({},1)
-- FightSystem.player_card_system = CardsSystem:New()
FightSystem.Round = {}
FightSystem.Round.round_num = 0
FightSystem.Round.is_first = true
FightSystem.Round.is_self = true

------------------------------------ 功能实现 ------------------------------------

-- 双方约定战斗后调用
function FightSystem:StartFight()
    -- 初始化round
    -- 初始化UI
    self:LoadUI()
end

-- 开始战斗后加载UI
function FightSystem:LoadUI()
    EventSystem.Send("OpenUI","player_rudder")
    EventSystem.Send("OpenUI","rivial_rudder")
    EventSystem.Send("OpenUI","PHP")
    EventSystem.Send("OpenUI","PMP")
    EventSystem.Send("OpenUI","PSP")
    EventSystem.Send("OpenUI","RHP")
    EventSystem.Send("OpenUI","RMP")
    EventSystem.Send("OpenUI","RSP")
end
-- 某一方玩家使用卡牌时调用
function FightSystem:SendCard(card_name)
    if self.is_self == true then
        self.card_system:UseCardFromHand(card_name)
        EventSystem.Send(card_name .. "_effect",self.Player_Attri,self.Rivial_Attri)
        EventSystem.Send(card_name .. "_display")
    end
end

-- 超时或玩家结束回合时调用
function FightSystem:EndRound()
    if self.is_self == true then
        self.Round.round_num = self.Round.round_num + 0.5
        -- 把控制权移交给对手
        self.is_self = false
        -- 发送控制切换请求

    end
end

-- 轮到自己回合
function FightSystem:StartRound()
    -- 获取控制权
    self.is_self = true
    -- 更新卡牌系统
    self.card_system:GetCardFromBag()
end

-- 因某种事件结束战斗时调用
function FightSystem:EndFight()
    self.round_num = 0
    self.Rivial_Attri = nil
    self.Player_Attri = nil
end
                    
-- 事件注册
EventSystem.Add("StartFight",false,FightSystem:StartFight)
EventSystem.Add("SendCard",false,FightSystem:SendCard)
EventSystem.Add("EndRound",false,FightSystem:EndRound)
EventSystem.Add("EndFight",false,FightSystem:EndFight)

function Global.Update()
    if self.card_system == true then
        local cards_list = self.card_system:GetHandCard()
        card_list
    end
    -- 实现卡牌拖拽效果
    if self.
end