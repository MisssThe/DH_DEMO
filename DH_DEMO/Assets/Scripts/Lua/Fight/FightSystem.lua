-- 管理卡牌战斗
-- 接收玩家指令并执行逻辑
-- 接收双方玩家操作并通过网络交互
require("Assets/Scripts/Lua/EventSystem.lua")

Global.FightSystem = {}
-- 读取玩家（属性，资源）
function FightSystem.StartFight(player1,player2)
    -- 根据玩家数据初始化卡牌系统

end

function FightSystem.UseCard(index,isSelf)

end

EventSystem.Add("StartFight",false,FightSystem.StartFight)
EventSystem.Add("UseCard",false,FightSystem.UseCard)