-- 实现UI管理功能（最基本的打开及关闭UI，以及UI排序）
require("framework.SharedTools")
require("Assets/Scripts/Lua/UIBase.lua")
Global.UIManager = {}
-----------------------------------------UI管理具体功能实现-----------------------------------------

-- 实现manager实例化功能
function Global.UIManager:New()
    print("get ui manager!")
    return UIManager
end

-- 实现添加ui功能
Global.UIManager.ui_list = CreateList()

function Global.UIManager:AddUI(ui)
    if (ui ~= nil and ui.ui_id ~= nil) then
        ui_list.Add(ui.ui_id,ui)
    end
end

-- 实现释放所有UI的功能
function Global.UIManager:ReleaseUI()
    -- 释放所有ui并清空ui表
    local flag
    local value
    value,flag = ui_list.Iterator()
    while (flag)
    do
        value.Close()
        value,flag = ui_list.Iterator()
    end
    ui_list.Clear()
end

-- 实现manager打开UI功能
UIManager.wrong_load_num = 0
UIManager.max_wrong_load_num = 4
 function Global.UIManager:OpenUI(ui_id)
    -- 判断ui是否已加载
    print("open ui!")
    temp_ui = Global.UIManager.ui_list.Search(ui_id)
    if temp_ui ~= nil then
        temp_ui.Resume()
        wrong_load_num = 0
    else
        -- 若不存在则使用资源管理器加载
    end
end
-- 实现manager关闭UI功能

function Global.UIManager:CloseUI(ui_id)
    print("close ui")
    if (ui_id > 0) then
        temp_ui = ui_list.Search(ui_id)
        if (temp_ui ~= nil)  then
            temp_ui.Search(ui_id).Hide()
        end
    else
        -- 获取选择对象以取得父Canvas并关闭
        temp_ui = GetSelectObj().transform
        while temp_ui ~= nil
        do
            if temp_ui:GetComponent(typeof(CS.UnityEngine.Canvas)) ~= nil
            then
                break
            end
            temp_ui = temp_ui.parent
        end
        -- ！需要修改！
        ui_base = temp_ui.UIBase
        if (ui_base ~= nil) then
            temp_ui_id = ui_base.GetID()
            if temp_ui_id > 0 then
                CloseUI(temp_ui_id)
            end
        end
    end
end