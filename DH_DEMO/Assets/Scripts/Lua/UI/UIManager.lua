-- 实现UI管理功能（最基本的打开及关闭UI，以及UI排序）
require("Assets/Scripts/Lua/SharedTools")
require("Assets/Scripts/Lua/UI/UIView")
require("Assets/Scripts/Lua/SourceManager")
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
        if (temp_ui ~= nil) then
            ui_list.Add(ui.ui_name,ui)
        end
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
    local temp_ui = UIManager.ui_list.Search(ui_id)
    if temp_ui ~= nil then
        temp_ui.Resume()
    else
        -- 若不存在则使用资源管理器加载
        Addressiable:GetObjAsync(ui_name)
    end
end

-- 实现manager关闭UI功能
-- name为空时关闭自身
function Global.UIManager:CloseUI(ui_name)
    print("close ui")
    if (ui_name ~= nil) then
        local temp_ui = ui_list.Search(ui_name)
        temp_ui.Search(ui_id).Hide()
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