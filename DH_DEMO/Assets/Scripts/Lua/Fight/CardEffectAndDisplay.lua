
---------------------------- 攻击牌 ----------------------------
local NormalAttack = {}
function NormalAttack.Effect(play1,play2)
  local real_d = play1:Attack(3)
  for i = 0,4,1 do
      play2:ReduceHP(real_d,true)
  end
end
function NormalAttack.Display()
end
EventSystem.Add('NormalAttack_Effect',false,NormalAttack.Effect)
EventSystem.Add('NormalAttack_Display',false,NormalAttack.Display)
local ToBlow = {}
function ToBlow.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,10,1 do
      play2:ReduceHP(real_d,false)
  end
end
function ToBlow.Display()
end
EventSystem.Add('ToBlow_Effect',false,ToBlow.Effect)
EventSystem.Add('ToBlow_Display',false,ToBlow.Display)
local OneTwoPunch = {}
function OneTwoPunch.Effect(play1,play2)
  local real_d = play1:Attack(10)
  for i = 0,1,1 do
      play2:ReduceHP(real_d,false)
  end
end
function OneTwoPunch.Display()
end
EventSystem.Add('OneTwoPunch_Effect',false,OneTwoPunch.Effect)
EventSystem.Add('OneTwoPunch_Display',false,OneTwoPunch.Display)
local ShieldBash = {}
function ShieldBash.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,5,1 do
      play2:ReduceHP(real_d,false)
  end
end
function ShieldBash.Display()
end
EventSystem.Add('ShieldBash_Effect',false,ShieldBash.Effect)
EventSystem.Add('ShieldBash_Display',false,ShieldBash.Display)
local PunctureSpear = {}
function PunctureSpear.Effect(play1,play2)
  local real_d = play1:Attack(1)
  for i = 0,5,1 do
      play2:ReduceHP(real_d,turu)
  end
end
function PunctureSpear.Display()
end
EventSystem.Add('PunctureSpear_Effect',false,PunctureSpear.Effect)
EventSystem.Add('PunctureSpear_Display',false,PunctureSpear.Display)
---------------------------- 辅助牌 ----------------------------
local magic_flag = false
local max_time = 3
local now_time = 0
local now_buff = nil
local magic_obj = nil
local magic_obj1 = nil
local function UseMagic(color,flag)
  print("播放成功")
  local magic_animation = nil
  local magic_material = nil
  if flag then
    magic_material = FightSystem.Effect.player_effect.buff.buff_material
    magic_animation = FightSystem.Effect.player_effect.buff.buff_animation
    magic_obj = FightSystem.Effect.player_effect.buff.buff_obj
    magic_obj1 = FightSystem.Effect.player_effect.buff.buff_particel
    print(magic_material == nil)
    print(magic_animation.name)
    print(FightSystem.Effect.rivial_effect.buff.buff_animation.name)
    print(magic_obj == nil)
    -- now_buff = 
  else
    magic_material = FightSystem.Effect.rivial_effect.buff.buff_material
    magic_animation = FightSystem.Effect.rivial_effect.buff.buff_animation
    magic_obj = FightSystem.Effect.rivial_effect.buff.buff_obj
    magic_obj1 = FightSystem.Effect.rivial_effect.buff.buff_particel
  end
  magic_obj.gameObject:SetActive(true)
  magic_obj1.gameObject:SetActive(true)
  magic_animation:Play("Magic")
  for i = 0,4,1 do
    magic_material[i].material.color = color
  end
  magic_obj1:GetComponent(typeof(UE.ParticleSystem)).main.startColor = UE.ParticleSystem.MinMaxGradient(color)
  magic_flag = true
  now_time = 0
end

EventSystem.Add("UseMagic",true,UseMagic)
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





function Global.Update()
  -- buff场最多存在3s
  print("qqqqqqqqq")
  if magic_flag == true then
    print("llllllllllllll")
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