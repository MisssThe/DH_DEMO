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
    if FightSystem.Player_Attri ~= nil then
        if FightSystem.Player_Attri.flag == true then
            print("属性发生变化")
            -- 更新生命值、法力值、护甲值
            p_hp_material:SetFloat("_Percent",FightSystem.Player_Attri:GetPercentHP())
            p_mp_material:SetFloat("_Percent",FightSystem.Player_Attri:GetPercentMP())
            p_sp_material:SetFloat("_Percent",FightSystem.Player_Attri:GetPercentSP())
            FightSystem.Player_Attri.flag = false
        end
        if FightSystem.Rivial_Attri.flag == true then
            print("敌方属性发生变化")
            r_hp_material:SetFloat("_Percent",FightSystem.Rivial_Attri:GetPercentHP())
            r_mp_material:SetFloat("_Percent",FightSystem.Rivial_Attri:GetPercentMP())
            r_sp_material:SetFloat("_Percent",FightSystem.Rivial_Attri:GetPercentSP())
            FightSystem.Rivial_Attri.flag = false
        end
    end
end