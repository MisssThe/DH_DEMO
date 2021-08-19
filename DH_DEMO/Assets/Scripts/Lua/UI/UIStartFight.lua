require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/EventSystem.lua")
-- require("")
local start_view = UIView:New(cs_self.gameObject)
print("init start fight")
local function StartFight()
    start_view:Hide()
    if FightSystem.player_info.rivial_name ~= nil and FightSystem.player_info.self_name ~= nil then
    -- 发起战斗
    print("尝试发起战斗" .. FightSystem.player_info.self_name .. FightSystem.player_info.rivial_name)
        CS.NetWork.SendToFight(FightSystem.player_info.self_name,FightSystem.player_info.rivial_name)
    end
    -- CS.NetWork.SendToFight("222","Sean")
end
local a_b = cs_self.gameObject:GetComponent(typeof(UI.Button))
a_b.onClick:AddListener(StartFight)

local canvas = UE.GameObject.FindGameObjectsWithTag("Canvas")[0]
cs_self.gameObject.transform:SetParent(canvas.transform)
cs_self.transform.localPosition = UE.Vector3(0,0,0)
cs_self.transform.localScale = UE.Vector3(3,3,1)