-- 实现UI管理功能（最基本的打开及关闭UI，以及UI排序）
require("framework.SharedTools")
require("Assets/Scripts/Lua/SourceManager")
require("Assets/Scripts/Lua/EventSystem.lua")

Global.UIManager = {}
-----------------------------------------UI管理具体功能实现-----------------------------------------
-- 实现manager实例化功能
function Global.UIManager:New()
    print("get ui manager!")
    return UIManager
end

-- 实现添加ui功能
-- 添加的物体为整个ui对象
Global.UIManager.ui_list = CreateList()

function Global.UIManager:AddUI(ui)
    if (ui ~= nill) then
        self.ui_list.Add(ui.ui_name,ui)
        print("add ui succed!")
    end
end

-- 实现释放所有UI的功能
function Global.UIManager:ReleaseUI()
    -- 释放所有ui并清空ui表
    local flag,value
    value,flag = ui_list.Iterator()
    while (flag)
    do
        value.Close()
        value,flag = ui_list.Iterator()
    end
    ui_list.Clear()
end

-- 实现manager打开UI功能
function UIManager:OpenUI(ui_name)
    -- 判断ui是否已加载
    local temp_ui = self.ui_list.Search(ui_id)
    if temp_ui ~= nil then
        temp_ui.Resume()
    else
        -- 若不存在则使用资源管理器加载
        ASS.InstantiateAsync(ui_name)
    end
end

-- 实现manager关闭UI功能
-- name为空时关闭自身
function Global.UIManager.CloseUI(ui_name)
    print("close ui")
    print(ui_name)
    if (ui_name ~= nil) then
        print(UIManager.ui_list.Search("im2") == nil)
        local temp_ui = UIManager.ui_list.Search(ui_name)
        temp_ui.Hide()
    else
        -- 获取选择对象以取得父Canvas并关闭
        temp_ui = GetSelectObj().transform
        while temp_ui ~= nil
        do
            if temp_ui:GetComponent(type(CS.UnityEngine.Canvas)) ~= nil then
                break
            end
            temp_ui = temp_ui.parent
        end
        if temp_ui ~= nil then
            local ui_name = temp_ui.name
            CloseUI(ui_name)
        end
    end
end

EventSystem.Add("OpenUI",false,UIManager.OpenUI)
EventSystem.Add("CloseUI",false,UIManager.CloseUI)







--------------------------------------------------------------------------------------------------------------
-- UI基类，封装基本功能，后续UI继承此类并拓展
-- 不能直接使用
require("framework.SharedTools")
require("Assets/Scripts/Lua/EventSystem.lua")

Global.UIView = {}
UIView.__index = UIView
UIView.status = {"OPEN","CLOSE","HIDE"}
UIView.status = CreateEnum(UIView.status)
UIView.ui_name = nil
----------------------------功能实现----------------------------
function UIView:New()
    local temp_ui = {}
    setmetatable(temp_ui,self)
    if (cs_self.gameObject ~= nil) then
        cs_self.gameObject:SetActive(false)
        temp_ui.status = UIView.status["HIDE"]
        temp_ui.ui_name = cs_self.gameObject.name
        UIManager:AddUI(temp_ui)
        UIManager:OpenUI(temp_ui.ui_name)
    end
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
print("load ui manager!")