
--------------------------------------------------------------------------------------------------------------
-- UI基类，封装基本功能，后续UI继承此类并拓展
-- 不能直接使用
require("Assets/Scripts/Lua/EventSystem.lua")
local status_enum = {"OPEN","CLOSE","HIDE"}
status_enum = CreateEnum(status_enum)
Global.UIView = {}
UIView.__index = UIView
UIView.status = nil
UIView.ui_name = nil
----------------------------功能实现----------------------------
function UIView:New(gameObject)
    local temp_ui = {}
    setmetatable(temp_ui,self)
    if (gameObject ~= nil) then
        temp_ui.gameObject = gameObject
        temp_ui.gameObject:SetActive(false)
        temp_ui.status = status_enum["HIDE"]
        temp_ui.ui_name = gameObject.name
        EventSystem.Send("AddUI",temp_ui)
    else
        return nil
    end
    return temp_ui
end

function UIView:GetName()
    return self.gameObject.name
end

-- 从资源中加载UI
function UIView:Resume()
    if self.status == status_enum["HIDE"] then
        self.status = status_enum["OPEN"]
        self.gameObject:SetActive(true)
    end
end

function UIView:Hide()
    if self.status == status_enum["OPEN"] then
        self.gameObject:SetActive(false)
        self.status = status_enum["HIDE"]
    end
end

function UIView:Close()
    if self.status ~= status_enum["CLOSE"] then
        self.status = status_enum["CLOSE"]
        CS.UnityEngine.Destroy(cs_self)
    end
end

function UIView:MoveTop(m_object)
    if (m_object ~= nil) then
        m_object.gameObject.transform:SetSiblingIndex(m_object.childCount)
    end
end

function UIView:MoveTopSelf()
    self.gameObject.transform.parent:SetSiblingIndex(self.gameObject.transform.parent.parent.childCount)
end

-- 移动ui
-- function UIView:Move(pos)
--     self.gameObject.transform.localPosition = 
-- end
setmetatable(UIView,__metatable)