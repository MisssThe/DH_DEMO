-- UI基类，封装基本功能，后续UI继承此类并拓展
-- 不能直接使用
require("Assets/Scripts/Lua/SharedTools")
Global.UIView = {}
UIView.__index = UIView
UIView.status = {"OPEN","CLOSE","HIDE"}
UIView.status = CreateEnum(UIView.status)
UIView.ui_name = nil

----------------------------功能实现----------------------------
function UIView:New()
    local temp_ui = {}
    setmetatable(temp_ui,self)
    if (cs_self ~= nil) then
        cs_self.gameObject:SetActive(false)
    end
    temp_ui.status = UIView.status["HIDE"]
    temp_ui.ui_name = cs_self.gameObject.name
    UIManager:AddUI(temp_ui)
    UIManager:OpenUI(temp_ui.ui_name)
    return temp_ui
end

function UIView:GetName()
    return self.gameObject.name
end

-- 从资源中加载UI
function UIView:Resume()
    if self.status == UIView.status[HIDE] then
        self.status = UIView.status[OPEN]
        cs_self.gameObject:SetActive(true)
    end
end

function UIView:Hide()
    if self.status == UIView.status[OPEN] then
        cs_self.gameObject:SetActive(false)
        self.status = UIView.status[HIDE]
    end
end

function UIView:Close()
    if self.status ~= UIView.status[CLOSE] then
        self.status = UIView.status[CLOSE]
        CS.UnityEngine.Destroy(cs_self)
    end
end

setmetatable(UIView,__metatable)