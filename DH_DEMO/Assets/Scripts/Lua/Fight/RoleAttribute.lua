Global.RoleAttribute = {}
RoleAttribute.__index = RoleAttribute
RoleAttribute.is_alive = true
RoleAttribute.health_point = {}
RoleAttribute.health_point.max_hp = 0
RoleAttribute.health_point.now_hp = 0
RoleAttribute.magic_point = {}
RoleAttribute.magic_point.max_mp = 0
RoleAttribute.magic_point.now_mp = 0
RoleAttribute.shield_point = {}
RoleAttribute.shield_point.max_sp = 0
RoleAttribute.shield_point.now_sp = 0
RoleAttribute.shield_point.one_sp = 0
RoleAttribute.shield_point.ned_sp = 0
-- 先计算buff在计算debuff
RoleAttribute.buff_list = {}
RoleAttribute.buff_index = 0
RoleAttribute.debuff_list = {}
RoleAttribute.debuff_index = 0
RoleAttribute.flag = true
RoleAttribute.name = nil
-- Buff效果：
--     增加造成伤害 IMD
--     减少受到伤害 RYD
--     增加治疗效果 ITE
--     减少法力消耗 RMC
-- Debuff效果：
--     增加受到伤害 IYD
--     减少造成伤害 RMD
--     减少治疗效果 RTE
--     增加法力消耗 IMC
Global.buff_type = {"IMD","RYD","ITE","RMC","IYD","RMD","RTE","IMC"}
buff_type = CreateEnum(buff_type)
-------------------------------------- 功能实现 --------------------------------------
function RoleAttribute:New(hp,mp,sp,one_sp,ned_sp,role_name)
    local temp = {}
    setmetatable(temp,RoleAttribute)
    if (hp ~= nil and mp ~= nil and sp ~= nil and one_sp ~= nil and ned_sp ~= nil) then
        temp.name = role_name
        temp.health_point = {}
        temp.magic_point = {}
        temp.shield_point = {}
        temp.health_point.max_hp = hp
        print(temp.health_point.max_hp)
        temp.health_point.now_hp = hp
        print(temp.health_point.now_hp)
        temp.magic_point.max_mp = mp
        print(temp.magic_point.max_mp)
        temp.magic_point.now_mp = mp * 0.3
        print(temp.magic_point.now_mp)
        temp.shield_point.max_sp = sp
        temp.shield_point.now_sp = sp * 0.2
        temp.shield_point.one_sp = one_sp
        temp.shield_point.ned_sp = ned_sp
        temp.is_alive = true
    end
    return temp
end
-- 造成伤害
function RoleAttribute:Attack(num)
    print("本来的伤害为：" .. num)
    num = self:CaculateBuff(num,buff_type["IMD"],buff_type["RMD"])
    print("增益后的伤害为:" .. num)
    return num
end
-- 治疗效果
function RoleAttribute:IncreaseHP(num)
    self.flag = true
    num  = self:CaculateBuff(num,buff_type["ITE"],buff_type["RTE"])
    self.health_point.now_hp = self.health_point.now_hp + num
    if self.health_point.now_hp > self.health_point.max_mp then
        self.health_point.now_hp = self.health_point.max_mp
    end
end
-- 受到伤害
function RoleAttribute:ReduceHP(num,fixed)
    self.flag = true
    print(self.name .. "的生命值减少了" .. num)
    num  = self:CaculateBuff(num,buff_type["RYD"],buff_type["IYD"])
    print("即将受到的伤害为：" .. num)
    if fixed then
        self.health_point.now_hp = self.health_point.now_hp - num
    else
        -- 先计算护甲
        local one_def = self.shield_point.now_sp // self.shield_point.ned_sp * self.shield_point
        self.shield_point.now_sp = self.shield_point.now_sp - num / one_def
        if (self.shield_point.now_sp < 0) then
            self.health_point.now_hp = self.health_point.now_hp - self.shield_point.now_sp * one_def
            self.shield_point.now_sp = 0
        end
    end
    -- 若生命值小于零则死亡
    if self.health_point.now_hp <= 0 then
        self.is_alive = false
        EventSystem.Send("EndFight",false)
    end
end
-- 回复法力值
function RoleAttribute:IncreaseMP(num)
    self.flag = true
    self.magic_point.now_sp = self.magic_point.now_sp + num
    if self.magic_point.now_mp > self.magic_point.max_mp then
       self.magic_point.now_mp = self.magic_point.max_mp 
    end
end
-- 消耗法力值
function RoleAttribute:ReduceMP(num)
    self.flag = true
    num  = self:CaculateBuff(num,buff_type["RMC"],buff_type["IMC"])
    local temp_mp = self.magic_point.now_sp - num
    if temp_mp > 0 then
        self.magic_point.now_sp = temp_mp
        return true
    else
        -- 施法失败
        return false
    end
end

-- 增加护甲值
-- 护甲可以承担更多的伤害值
-- 当护甲每积累一定值，没点护甲可以抵挡更多伤害
function RoleAttribute:IncreaseSP(num)
    self.flag = true
    self.shield_point.now_sp = self.shield_point.now_sp + num
end

Global.Buff = {}
Buff.type = nil
Buff.value = nil
Buff.time = nil

Buff.__index = Buff
function Buff:New(time,bt,value)
    local temp = {}
    setmetatable(temp,Buff)
    temp.type = buff_type[bt]
    temp.value = value
    temp.time = time
    return temp
end

-- 添加一个buff（增加造成伤害，减少受到伤害，持续时间）
function RoleAttribute:AddBuff(time,value,bt)
    print("增加一个buff")
    print(time .. "," .. bt .. "," .. value)
    local buff = Buff:New(time,bt,value)
    self.buff_list[self.buff_index] = buff
    print(self.buff_list[self.buff_index].value)
    self.buff_index = self.buff_index + 1
    self.flag = true
end
function RoleAttribute:UpdateBuff()
    -- 判断是否有buff到期
end
-- 删除n个buff
function RoleAttribute:DeleteBuff(n)
    self.flag = true
    local o = 0
    for i,v in pairs(self.buff_list)
    do 
        if o < n then
            break
        end
        o = o + 1
        self.buff_list[i] = nil
    end
end
-- 添加一个debuff（增加受到伤害，减少造成伤害，持续时间）
function RoleAttribute:AddDebuff(time,value,bt)
    local buff = Buff:New(time,bt,value)
    self.flag = true
    self.debuff_list[self.debuff_index] = buff
    self.debuff_index = self.debuff_index + 1
end
-- 删除n个debuff
function RoleAttribute:DeleteDebuff(n)
    self.flag = true
    local o = 0
    for i,v in pairs(self.debuff_list)
    do 
        if o < n then
            break
        end
        o = o + 1
        self.debuff_list[i] = nil
    end
end

-- 计算buff效果后的结果
function RoleAttribute:CaculateBuff(value,type1,type2)
    for i,v in pairs(self.buff_list)
    do
        -- print(v)
        if v.type == type1 then
            value = value + v.value
        end
    end

    for i,v in pairs(self.debuff_list)
    do
        if v.type == type2 then
            value = value + v.value
        end
    end
    return value
end

function RoleAttribute:GetPercentHP()
    return self.health_point.now_hp / self.health_point.max_hp
end
function RoleAttribute:GetPercentMP()
    return self.magic_point.now_mp / self.magic_point.max_mp
end

function RoleAttribute:GetPercentSP()
    return self.shield_point.now_sp / self.shield_point.max_sp
end