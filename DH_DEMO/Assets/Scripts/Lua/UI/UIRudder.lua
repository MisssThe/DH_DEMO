require("Assets/Scripts/Lua/EventSystem.lua")
require("Assets/Scripts/Lua/UI/UIView.lua")
require("Assets/Scripts/Lua/Fight/FightSystem.lua")

Global.rivial_rudder = nil
Global.player_rudder = nil
local rr_view = nil
local pr_view = nil
local rr_animation = nil
local pr_animation = nil
local flag = true
local old_time = 0
local function EventFunc2()
    local t = UE.Time.time
    if t - old_time > 2 then
        EventSystem.Send("PlayFightTurnRound")
        old_time = t
        -- 播放一次动画
        if flag then
            pr_animation:Play("ChangeRound1")
            rr_animation:Play("ChangeRound2")
            flag = false
        else
            pr_animation:Play("ChangeRound2")
            rr_animation:Play("ChangeRound1")
            flag = true
        end
    end
end

local function EventFunc()
    print("点击成功")

    if FightSystem.Round.is_self then
        EventFunc2()
        EventSystem.Send("EndRound")
    end
end

EventSystem.Add("ChangeRound",false,EventFunc2)
function Global.Awake()
    rr_view = UIView:New(rivial_rudder.gameObject)
    pr_view = UIView:New(player_rudder.gameObject)
    rr_animation = rivial_rudder:GetComponent(typeof(UE.Animator))
    pr_animation = player_rudder:GetComponent(typeof(UE.Animator))
    pr_animation:Stop()
    rr_animation:Stop()
    -- 添加点击事件
    rivial_rudder:GetComponent(typeof(UI.Button)).onClick:AddListener(EventFunc)
    player_rudder:GetComponent(typeof(UI.Button)).onClick:AddListener(EventFunc)
    old_time = UE.Time.time
end
