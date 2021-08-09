require("Assets/Scripts/Lua/UI/UIManager.lua")
----------------------------事件函数----------------------------
local function EventFunc()
    -- 打开一个image
    -- EventSystem.Send("OpenUI","im2")
    -- 关闭image
    EventSystem.Send("CloseUI","im2")
    print("event ~!!!!!!!!!!!!!!")
end
----------------------------生命周期----------------------------
local ui_view = {}
function Global.Awake()
    ui_view = UIView:New()
    -- print(typeof(UI.Button))
    button = cs_self.gameObject:GetComponent(typeof(UI.Button))
    button.onClick:AddListener(EventFunc)
end

function Global.OnDestroy()
end
print("load ui button!")