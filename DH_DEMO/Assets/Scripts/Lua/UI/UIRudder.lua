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
local function EventFunc()
    if FightSystem.Round.is_self then
        local t = UE.Time.time
        if t - old_time > 2 then
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
            EventSystem.Send("EndRound")
        end
    end
end
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
