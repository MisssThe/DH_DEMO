---------------------------- 攻击牌 ----------------------------
local Normal1 = {}
function Normal1.Effect()
  local real_d = FightSystem.Player_Attri:Attack(2)
  for i = 0,4,1 do
      FightSystem.Rivial_Attri:ReduceHP(real_d)
  end
end
function Normal1.Display()
end
EventSystem.Add('Normal1_Effect',false,Normal1.Effect)
EventSystem.Add('Normal1_Display',false,NormalAttack.Display)
local Normal2 = {}
function Normal2.Effect()
  local real_d = FightSystem.Player_Attri:Attack(1)
  for i = 0,5,1 do
      FightSystem.Rivial_Attri:ReduceHP(real_d)
  end
end
function Normal2.Display()
end
EventSystem.Add('Normal2_Effect',false,Normal2.Effect)
EventSystem.Add('Normal2_Display',false,NormalAttack.Display)
local Normal3 = {}
function Normal3.Effect()
  local real_d = FightSystem.Player_Attri:Attack(1)
  for i = 0,2,1 do
      FightSystem.Rivial_Attri:ReduceHP(real_d)
  end
end
function Normal3.Display()
end
EventSystem.Add('Normal3_Effect',false,Normal3.Effect)
EventSystem.Add('Normal3_Display',false,NormalAttack.Display)
local Normal4 = {}
function Normal4.Effect()
  local real_d = FightSystem.Player_Attri:Attack(3)
  for i = 0,1,1 do
      FightSystem.Rivial_Attri:ReduceHP(real_d)
  end
end
function Normal4.Display()
end
EventSystem.Add('Normal4_Effect',false,Normal4.Effect)
EventSystem.Add('Normal4_Display',false,NormalAttack.Display)
local Normal5 = {}
function Normal5.Effect()
  local real_d = FightSystem.Player_Attri:Attack(2)
  for i = 0,5,1 do
      FightSystem.Rivial_Attri:ReduceHP(real_d)
  end
end
function Normal5.Display()
end
EventSystem.Add('Normal5_Effect',false,Normal5.Effect)
EventSystem.Add('Normal5_Display',false,NormalAttack.Display)
---------------------------- 辅助牌 ----------------------------
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
  FightSystem.Player_Attri:AddDebuff(-1,'RTE')
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
---------------------------- 咒术牌 ----------------------------
