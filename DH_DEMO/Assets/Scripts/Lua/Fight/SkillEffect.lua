Global.SkillEffect = {}

SkillEffect.shield = nil
SkillEffect.shield_obj = nil
SkillEffect.buff = {}
SkillEffect.attack = nil
SkillEffect.__index = SkillEffect
function SkillEffect:New(name)
    local obj = UE.GameObject.FindGameObjectsWithTag("UserShip")
    local length = obj.Length - 1
    local ship = nil
    print("name")
    for i = 0,length,1 do
        print(obj[i].name)
        if obj[i].name == name then
            ship = obj[i]
        end
    end
    if ship ~= nil then
        obj = ship:GetComponentsInChildren(typeof(UE.Transform))
        length = obj.Length - 1
        if length == 0 then
            return nil
        end
        local base_magic = nil
        local base_shield = nil
        for i = 1,length,1 do
            if obj[i].tag == "BuffSkill" then
                base_magic = obj[i]
            end
            if obj[i].tag == "ShieldSkill" then
                base_shield = obj[i]
            end
        end
        local temp = {}
        setmetatable(temp,SkillEffect)
        temp.shield_obj = base_shield
        temp.shield = base_shield:GetComponent(typeof(UE.MeshRenderer)).material
        temp.buff = {}
        
        temp.buff.buff_obj = base_magic:GetChild(1)
        temp.buff.buff_particel = base_magic:GetChild(0)
        temp.buff.buff_animation = temp.buff.buff_obj:GetComponent(typeof(UE.Animator))
        temp.buff.buff_material = temp.buff.buff_obj:GetComponentsInChildren(typeof(UE.MeshRenderer))
        return temp
    else
        print("没找到对应物体")
    end
end