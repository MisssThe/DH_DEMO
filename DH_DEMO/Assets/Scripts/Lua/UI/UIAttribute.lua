require("Assets/Scripts/Lua/EventSystem.lua")
require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/Fight/FightSystem.lua")
Global.p_hp_obj = nil
Global.p_mp_obj = nil
Global.p_sp_obj = nil
Global.r_hp_obj = nil
Global.r_mp_obj = nil
Global.r_sp_obj = nil
local p_hp_view = nil
local p_mp_view = nil
local p_sp_view = nil
local r_hp_view = nil
local r_mp_view = nil
local r_sp_view = nil
local p_hp_material = nil
local p_mp_material = nil
local p_sp_material = nil
local r_hp_material = nil
local r_mp_material = nil
local r_sp_material = nil

function Global.Awake()
    p_hp_view = UIView:New(p_hp_obj.gameObject)
    p_mp_view = UIView:New(p_mp_obj.gameObject)
    p_sp_view = UIView:New(p_sp_obj.gameObject)

    p_hp_material = p_hp_obj:GetComponent(typeof(UI.Image)).material
    p_mp_material = p_mp_obj:GetComponent(typeof(UI.Image)).material
    p_sp_material = p_sp_obj:GetComponent(typeof(UI.Image)).material

    r_hp_view = UIView:New(r_hp_obj.gameObject)
    r_mp_view = UIView:New(r_mp_obj.gameObject)
    r_sp_view = UIView:New(r_sp_obj.gameObject)
    r_hp_material = r_hp_obj:GetComponent(typeof(UI.Image)).material
    r_mp_material = r_mp_obj:GetComponent(typeof(UI.Image)).material
    r_sp_material = r_sp_obj:GetComponent(typeof(UI.Image)).material
end

function Global.Update()
    if Player_Attri.flag == true then
        -- 更新生命值、法力值、护甲值
        p_hp_material:SetFloat("_Percent",Player_Attri:GetPercentHP())
        p_mp_material:SetFloat("_Percent",Player_Attri:GetPercentMP())
        p_sp_material:SetFloat("_Percent",Player_Attri:GetPercentSP())
    end
    if Rivial_Attri.flag == true then
        r_hp_material:SetFloat("_Percent",Rivial_Attri:GetPercentHP())
        r_mp_material:SetFloat("_Percent",Rivial_Attri:GetPercentMP())
        r_sp_material:SetFloat("_Percent",Rivial_Attri:GetPercentSP())
    end
end