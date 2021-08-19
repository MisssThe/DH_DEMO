---------------------------- 攻击牌 ----------------------------
local Normal1 = {}
function Normal1.Effect(play1,play2)
  local real_d = play1:Attack(2)
  for i = 0,4,1 do
      play2:ReduceHP(real_d,true)
  end
end
function Normal1.Display()
end
EventSystem.Add('Normal1_Effect',false,Normal1.Effect)
EventSystem.Add('Normal1_Display',false,Normal1.Display)
local Normal2 = {}
function Normal2.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,5,1 do
      play2:ReduceHP(real_d,true)
  end
end
function Normal2.Display()
end
EventSystem.Add('Normal2_Effect',false,Normal2.Effect)
EventSystem.Add('Normal2_Display',false,Normal2.Display)
local Normal3 = {}
function Normal3.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,2,1 do
      play2:ReduceHP(real_d,true)
  end
end
function Normal3.Display()
end
EventSystem.Add('Normal3_Effect',false,Normal3.Effect)
EventSystem.Add('Normal3_Display',false,Normal3.Display)
local Normal4 = {}
function Normal4.Effect(play1,play2)
  local real_d = play1:Attack(3)
  for i = 0,1,1 do
      play2:ReduceHP(real_d,true)
  end
end
function Normal4.Display()
end
EventSystem.Add('Normal4_Effect',false,Normal4.Effect)
EventSystem.Add('Normal4_Display',false,Normal4.Display)
local Normal5 = {}
function Normal5.Effect(play1,play2)
  local real_d = play1:Attack(2)
  for i = 0,5,1 do
      play2:ReduceHP(real_d,true)
  end
end
function Normal5.Display()
end
EventSystem.Add('Normal5_Effect',false,Normal5.Effect)
EventSystem.Add('Normal5_Display',false,Normal5.Display)
---------------------------- 辅助牌 ----------------------------
local BlessingOfStrenth = {}
function BlessingOfStrenth.Effect(play1,play2)
  play1:AddBuff(1,'IMD')
end
function BlessingOfStrenth.Display()
end
EventSystem.Add('BlessingOfStrenth_Effect',false,BlessingOfStrenth.Effect)
EventSystem.Add('BlessingOfStrenth_Display',false,BlessingOfStrenth.Display)
local Economy = {}
function Economy.Effect(play1,play2)
  play1:AddDebuff(-1,'RTE')
end
function Economy.Display()
end
EventSystem.Add('Economy_Effect',false,Economy.Effect)
EventSystem.Add('Economy_Display',false,Economy.Display)
local Weakness = {}
function Weakness.Effect(play1,play2)
  play2:AddDebuff(2,'IYD')
end
function Weakness.Display()
end
EventSystem.Add('Weakness_Effect',false,Weakness.Effect)
EventSystem.Add('Weakness_Display',false,Weakness.Display)
---------------------------- 咒术牌 ----------------------------