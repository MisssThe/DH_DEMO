-- 管理所有其余玩家船的显示
local user_ship = {}

user_ship.model_name = nil
user_ship.pos = nil
user_ship.rotation = nil

local function user_ship:New(model_name,pos,rotation)
    local temp = {}
    setmetatable(temp,user_ship)
    temp.model_name = model_name
    temp.pos = pos
    temp.rotation = rotation
    return temp
end

local ShipsManager = {}
ShipsManager.ship_list = {}
ShipsManager.real_ship_list = {}
ShipsManager.flag = true

-- local Set = {}
-- Set.list = {}
-- function Set:Add(data)
--     -- 判断data是否存在
--     if list[data] == nil then
--         list[data] = 0
--     else
--         list[data] = 1
--     end
-- end
-- function Set:GetDataNotOnly()
--     -- 返回出现不止一次的数据
--     local set = {}
--     local index = 1
--     for i,v in pairs(self.list) do
--         if v > 0 then
--             set[index] = i
--         end
--     end
--     return set
-- end
-- ship_list结构（ship_name,ship_attri）
function ShipsManager.UpdateShips(ship_list)
    -- 删去不需要的船,更新存在的船
    for i,v in pairs(ShipsManager.ship_list) 
    do
        if ship_list[i] == nil then
            -- 删去不需要的船
            UE.Object.Destroy(ShipsManager.real_ship_list[i])
        else
            -- 更新现有的船
            ShipsManager.real_ship_list[i].transform.position = ship_list[i].pos
            ShipsManager.real_ship_list[i].transform.rotation = ship_list[i].rotation
        end
    end
    for i,v in pairs(ship_list)
    do
        if ShipsManager.ship_list[i] == nil then
            -- 添加不存在的船
            ShipsManager.real_ship_list[i] = UE.GameObject.Instantiate(v.model_name,v.pos,v.rotation)
        end
    end
    ShipsManager.flag = true
end