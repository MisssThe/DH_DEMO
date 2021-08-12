require("Assets/Scripts/Lua/EventSystem.lua")
require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/Fight/FightSystem.lua")
Global.hp_obj = nil
Global.mp_obj = nil
Global.sp_obj = nil
local hp_view = UIView:New(hp_obj.gameObject)
local mp_view = UIView:New(mp_obj.gameObject)
local sp_obj = UIView:New(sp_obj.gameObject)

function Global.Update()
    if Player_Attri.flag == true then
        print("aaaaaaaaaaaaaaaaa")
    end
end