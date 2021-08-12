-- 管理卡牌战斗
-- 接收玩家指令并执行逻辑
-- 接收双方玩家操作并通过网络交互
require("Assets/Scripts/Lua/EventSystem.lua")
require("Assets/Scripts/Lua/Fight/RoleAttribute.lua")
-- -- 战斗角色
-- local FightRole = {}
-- FightRole.__index = FightRole
-- FightRole.HP = 0        -- 初始生命值
-- FightRole.MP = 0        -- 初始法力值
-- FightRole.CN = 0        -- 抽牌数
-- FightRole.IC = nil      -- 初始卡牌
-- FightRole.CS = nil      -- 初始卡牌系统
-- function FightRole:New(HP,MP,CN)
--     local temp = {}
--     setmetatable(temp,FightRole)
--     if HP ~= nil and MP ~= nil and CN ~= nil then
--         temp.HP = HP
--         temp.MP = MP
--         temp.CN = CN
--     end
--     return temp
-- end
-- function FightRole:UseCard(card_name)
--     card = self.CS.UseCard(card_name)
-- end

-- Global.FightSystem = {}
-- -- 读取玩家（属性，资源）
-- function FightSystem.StartFight(player1,player2)
--     -- 根据玩家数据初始化卡牌系统

-- end

-- function FightSystem.UseCard(card_name,isSelf)

-- end

-- EventSystem.Add("StartFight",false,FightSystem.StartFight)
-- EventSystem.Add("UseCard",false,FightSystem.UseCard)

-- print("ssssssssssssssssssssssssss")
-- print(RoleAttribute == nil)
Global.Rivial_Attri = RoleAttribute:New(10,10,10,10,1)
Global.Player_Attri = RoleAttribute:New(10,10,10,10,1)