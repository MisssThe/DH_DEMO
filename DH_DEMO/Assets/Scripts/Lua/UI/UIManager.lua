-- 实现UI管理功能（最基本的打开及关闭UI，以及UI排序）
require("Assets/Scripts/Lua/SourceManager")
require("Assets/Scripts/Lua/EventSystem.lua")

Global.UIManager = {}
-----------------------------------------UI管理具体功能实现-----------------------------------------
-- 实现manager实例化功能
-- function Global.UIManager.New()
--     print("get ui manager!")
--     return UIManager
-- end

-- 实现添加ui功能
-- 添加的物体为整个ui对象
Global.UIManager.ui_list = List:New()

function Global.UIManager.AddUI(ui)
    if (ui ~= nill) then
        UIManager.ui_list:Add(ui.ui_name,ui)
    end
end

-- 实现释放所有UI的功能
function Global.UIManager.ReleaseUI()
    -- 释放所有ui并清空ui表
    local flag,value
    value,flag = ui_list:Iterator()
    while (flag)
    do
        value.Close()
        value,flag = ui_list:Iterator()
    end
    ui_list.Clear()
end

-- 实现manager打开UI功能
function UIManager.OpenUI(ui_name)
    -- 判断ui是否已加载
    local ui_temp = UIManager.ui_list:Search(ui_name)
    if ui_temp ~= nil then
        ui_temp:Resume()
    else
        ASS.InstantiateAsync(ui_name)
    end
end

-- 实现manager关闭UI功能
-- name为空时关闭自身
function Global.UIManager.CloseUI(ui_name)
    if (ui_name ~= nil) then
        local ui_temp = UIManager.ui_list:Search(ui_name)
        if (ui_temp ~= nil) then
            ui_temp:Hide()
        end
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
EventSystem.Add("AddUI",false,UIManager.AddUI)

return UIManager