require("Assets/Scripts/Lua/UI/UIView.lua")

local animator = cs_self.gameObject:GetComponent(typeof(UE.Animator))

-- 注册或登录页面
ExEES.Send('ReciveLogin', "OvertureManager", cs_self.transform, cs_self.gameObject:GetComponent(typeof(UE.Animator)))

-- 注册事件
ExEES.Add(ExEES.Event:New("In", function(TRIGGLE) animator:SetTrigger(TRIGGLE) end, "loginpage"))
ExEES.Add(ExEES.Event:New("Out", function()

    animator:SetTrigger('Hidden')
    ExEES.Send('backMain', "OvertureManager")
end, "loginpage"))

function OnDestroy()
    ExEES.DeleteInst("loginpage")
end