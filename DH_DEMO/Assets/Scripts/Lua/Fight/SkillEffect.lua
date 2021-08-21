Global.SkillEffect = {}

SkillEffect.shield = nil
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
        obj = ship:GetComponentsInChildren(typeof(UE.transform))
        length = player.Length - 1
        if length == 0 then
            return nil
        end
        local base_magic = nil
        local base_shield = nil
        for i = 1,length,1 do
            if obj[i].tag == "BaseSkill" then
                base_magic = rivial[i]
            end
            if obj[i].tag == "ShieldSkill" then
                base_shield = rivial[i]:GetComponent(typeof(UE.MeshRenderer)).material
            end
        end
        local temp = {}
        setmetatable(temp,SkillEffect)
        temp.buff.buff_animation = base_magic:GetComponent(UE.Animator)
        temp.buff.buff_material = base_magic:GetComponentsInChildren(typeof(UE.MeshRenderer))
        return temp
    else
        print("没找到对应物体")
    end
end