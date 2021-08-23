require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/EventSystem.lua")
local accept_view = UIView:New(cs_self.gameObject)
local function AcceptFight()
    accept_view:Hide()
    -- 返回接收战斗
end
local function RefuseFigth()
    accept_view:Hide()
    -- 返回拒绝战斗
end
local a_b = cs_self.gameObject:GetComponent(typeof(UI.Button))
a_b.onClick:AddListener(AcceptFight)
a_b.onClick:AddListener(RefuseFigth)
local canvas = UE.GameObject.FindGameObjectsWithTag("Canvas")[0]
cs_self.gameObject.transform:SetParent(canvas.transform)
cs_self.transform.localPosition = UE.Vector3(0,0,0)
cs_self.transform.localScale = UE.Vector3(3,3,1)