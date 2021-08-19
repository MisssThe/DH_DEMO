-- 结束画面UI
Global.v_end_obj = nil
Global.d_end_obj = nil
Global.end_obj = nil
local v_end_view = UIView:New(v_end_obj.gameObject)
local d_end_view = UIView:New(d_end_obj.gameObject)
local end_view = UIView:New(end_obj.gameObject)
local temp_flag = true
local function EndFight()
    EventSystem.Send("RealEndFight")
    if temp_flag == true then
        EventSystem.Send("CloseUI","Victory")
    else
        EventSystem.Send("CloseUI","Defeated")
    end
end
local function OpenEnd()
    EventSystem.Send("EndFight",false)
end

v_end_obj.gameObject:GetComponent(typeof(UI.Button)).onClick:AddListener(EndFight)
d_end_obj.gameObject:GetComponent(typeof(UI.Button)).onClick:AddListener(EndFight)
end_obj.gameObject:GetComponent(typeof(UI.Button)).onClick:AddListener(OpenEnd)
local function ShowEndFight(flag)
    temp_flag = flag
    if flag == true then
        EventSystem.Send("OpenUI","Victory")
    else
        EventSystem.Send("OpenUI","Defeated")
    end
end



EventSystem.Add("ShowEndFight",flag,ShowEndFight)