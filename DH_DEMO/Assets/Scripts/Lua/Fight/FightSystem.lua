-- 管理卡牌战斗
-- 接收玩家指令并执行逻辑
-- 接收双方玩家操作并通过网络交互
require("Assets/Scripts/Lua/EventSystem.lua")
require("Assets/Scripts/Lua/Fight/RoleAttribute.lua")
Global.FightSystem = {}

FightSystem.Rivial_Attri = RoleAttribute:New(10,10,10,10,1)
FightSystem.Player_Attri = RoleAttribute:New(10,10,10,10,1)
FightSystem.player_card_system = CardsSystem:New()

------------------------------------ 功能实现 ------------------------------------

-- 双方约定战斗后调用
function FightSystem:StartFight()
end

-- 某一方玩家使用卡牌时调用
function FightSystem:SendCard()
end

-- 超时或玩家结束回合时调用
function FightSystem:ChangeRound()
end

-- 因某种事件结束战斗时调用
function FightSystem:EndFight()
end

-- 事件注册