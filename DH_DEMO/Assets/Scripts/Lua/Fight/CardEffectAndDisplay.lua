local magic_flag = false
local max_time = 3
local now_time = 0
local now_buff = nil
local magic_obj = nil
local magic_obj1 = nil
local function UseMagic(color,flag)
   local magic_animation = nil
   local magic_material = nil
   if flag then
       magic_material = FightSystem.Effect.player_effect.buff.buff_material
       magic_animation = FightSystem.Effect.player_effect.buff.buff_animation
       magic_obj = FightSystem.Effect.player_effect.buff.buff_obj
       magic_obj1 = FightSystem.Effect.player_effect.buff.buff_particel
   else
       magic_material = FightSystem.Effect.rivial_effect.buff.buff_material
       magic_animation = FightSystem.Effect.rivial_effect.buff.buff_animation
       magic_obj = FightSystem.Effect.rivial_effect.buff.buff_obj
       magic_obj1 = FightSystem.Effect.rivial_effect.buff.buff_particel
   end
   magic_obj.gameObject:SetActive(true)
   magic_obj1.gameObject:SetActive(true)
   magic_animation:Play('Magic')
   for i = 0,4,1 do
       magic_material[i].material.color = color
   end
   magic_obj1:GetComponent(typeof(UE.ParticleSystem)).main.startColor = UE.ParticleSystem.MinMaxGradient(color)
   magic_flag = true
   now_time = 0
end
function Global.Update()
   if magic_flag == true then
       if now_time > max_time then
       now_time = 0
       print(magic_obj.gameObject)
       magic_obj.gameObject:SetActive(false)
       magic_obj1.gameObject:SetActive(false)
       magic_flag = false
       else
       now_time = now_time + UE.Time.deltaTime
       end
   else
       now_time = 0
   end
end
---------------------------- 攻击牌 ----------------------------
--------------普通攻击--------------
local NormalAttack = {}
function NormalAttack.Effect(play1,play2)
  local real_d = play1:Attack(3)
  for i = 0,4,1 do
      play2:ReduceHP(real_d,true)
  end
end
function NormalAttack.Display(flag)
  EventSystem.Send('PlayAttackCard')
end
EventSystem.Add('NormalAttack_Effect',false,NormalAttack.Effect)
EventSystem.Add('NormalAttack_Display',false,NormalAttack.Display)
--------------奋力一击--------------
local ToBlow = {}
function ToBlow.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,10,1 do
      play2:ReduceHP(real_d,false)
  end
end
function ToBlow.Display(flag)
  EventSystem.Send('PlayAttackCard')
end
EventSystem.Add('ToBlow_Effect',false,ToBlow.Effect)
EventSystem.Add('ToBlow_Display',false,ToBlow.Display)
--------------连环打击--------------
local OneTwoPunch = {}
function OneTwoPunch.Effect(play1,play2)
  local real_d = play1:Attack(10)
  for i = 0,1,1 do
      play2:ReduceHP(real_d,false)
  end
end
function OneTwoPunch.Display(flag)
  EventSystem.Send('PlayAttackCard')
end
EventSystem.Add('OneTwoPunch_Effect',false,OneTwoPunch.Effect)
EventSystem.Add('OneTwoPunch_Display',false,OneTwoPunch.Display)
--------------盾击--------------
local ShieldBash = {}
function ShieldBash.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,5,1 do
      play2:ReduceHP(real_d,false)
  end
end
function ShieldBash.Display(flag)
  EventSystem.Send('PlayAttackCard')
end
EventSystem.Add('ShieldBash_Effect',false,ShieldBash.Effect)
EventSystem.Add('ShieldBash_Display',false,ShieldBash.Display)
--------------穿刺长矛--------------
local PunctureSpear = {}
function PunctureSpear.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,5,1 do
      play2:ReduceHP(real_d,turu)
  end
end
function PunctureSpear.Display(flag)
  EventSystem.Send('PlayAttackCard')
end
EventSystem.Add('PunctureSpear_Effect',false,PunctureSpear.Effect)
EventSystem.Add('PunctureSpear_Display',false,PunctureSpear.Display)
---------------------------- 辅助牌 ----------------------------
--------------力量祝福--------------
local BlessingOfStrenth = {}
function BlessingOfStrenth.Effect(play1,play2)
  play1:AddBuff(2,1,'IMD')
end
function BlessingOfStrenth.Display(flag)
  flag = (flag and true) or not(flag or true)
  UseMagic(UE.Color(1,0.87,0.67,1),flag)
  EventSystem.Send('PlayAssitCard')
end
EventSystem.Add('BlessingOfStrenth_Effect',false,BlessingOfStrenth.Effect)
EventSystem.Add('BlessingOfStrenth_Display',false,BlessingOfStrenth.Display)
--------------节约--------------
local Economy = {}
function Economy.Effect(play1,play2)
  play1:AddBuff(3,-1,'IMC')
end
function Economy.Display(flag)
  flag = (flag and true) or not(flag or true)
  UseMagic(UE.Color(0,0,1,1),flag)
  EventSystem.Send('PlayAssitCard')
end
EventSystem.Add('Economy_Effect',false,Economy.Effect)
EventSystem.Add('Economy_Display',false,Economy.Display)
--------------虚弱--------------
local Weakness = {}
function Weakness.Effect(play1,play2)
  play2:AddDebuff(2,2,'IYD')
end
function Weakness.Display(flag)
  flag = (flag and false) or not(flag or false)
  UseMagic(UE.Color(0,0,0,1),flag)
  EventSystem.Send('PlayAssitCard')
end
EventSystem.Add('Weakness_Effect',false,Weakness.Effect)
EventSystem.Add('Weakness_Display',false,Weakness.Display)
--------------补充营养--------------
local ExtraNutrition = {}
function ExtraNutrition.Effect(play1,play2)
  play1:AddBuff(2,5,'ITE')
end
function ExtraNutrition.Display(flag)
  flag = (flag and true) or not(flag or true)
  UseMagic(UE.Color(0.8,0,0,1),flag)
  EventSystem.Send('PlayAssitCard')
end
EventSystem.Add('ExtraNutrition_Effect',false,ExtraNutrition.Effect)
EventSystem.Add('ExtraNutrition_Display',false,ExtraNutrition.Display)
---------------------------- 咒术牌 ----------------------------
