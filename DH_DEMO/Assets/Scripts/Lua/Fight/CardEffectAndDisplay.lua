---------------------------- 攻击牌 ----------------------------
local 普通攻击 = {}
function 普通攻击.Effect()
    local real_d = FightSystem.Player_Attri:Attack(1)
    for i = 0,3,1 do
        FightSystem.Rivial_Attri:ReduceHP(real_d)
    end
end
function 普通攻击.Display()
end
EventSystem.Add('普通攻击_Effect',false,普通攻击.Effect)
EventSystem.Add('普通攻击_Display',false,NormalAttack.Display)

local 力量祝福 = {}
function 力量祝福.Effect()
    FightSystem.Player_Attri:AddBuff(1,'IMD')
end
function 力量祝福.Display()
end
EventSystem.Add('力量祝福_Effect',false,力量祝福.Effect)
EventSystem.Add('力量祝福_Display',false,力量祝福.Display)

local 节约 = {}
function 节约.Effect()
  FightSystem.Player_Attri:AddDebuff(-1,RTE)
end
function 节约.Display()
end
EventSystem.Add('节约_Effect',false,节约.Effect)
EventSystem.Add('节约_Display',false,节约.Display)

local 弱点暴露 = {}
function 弱点暴露.Effect()
  FightSystem.Rivial_Attri:AddDebuff(2,'IYD')
end
function 弱点暴露.Display()
end
EventSystem.Add('弱点暴露_Effect',false,弱点暴露.Effect)
EventSystem.Add('弱点暴露_Display',false,弱点暴露.Display)
