require("Assets/Scripts/Lua/UI/UIView.lua")
----------------------------事件函数----------------------------
local function EventFunc()
    -- 打开一个image
    -- EventSystem.Send("OpenUI","im2")
    -- 关闭image
    EventSystem.Send("CloseUI","im2")
end
----------------------------生命周期----------------------------
local ui_view = {}
function Global.Awake()
    ui_view = UIView:New(cs_self.gameObject)
    if ui_view ~= nil then
        button = cs_self.gameObject:GetComponent(typeof(UI.Button))
        button.onClick:AddListener(EventFunc)
    end
end

function Global.OnDestroy()
end