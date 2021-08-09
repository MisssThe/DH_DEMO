-- -- 抽象ship所有的操作
require("framework.SharedTools")
----------------------------------- 生命周期 --------------------------------
local ship

function Awake()
    if (cs_self ~= nil) then
        -- worldToLocalMatrix
    end
end
function Start()
end
function Update()
    -- print(UE.Time.time)
end
function FixedUpdate()
end
function LateUpdate()
end
function OnDestroy()
    print("destroy object")
end

Global.Ship = {}
Ship.__index = Ship

-------------------------------- 船体属性 --------------------------------
Ship.base_attri = {}
Ship.move_attri = {}
Ship.world_model = {}

-- -------------------------------- 功能实现 --------------------------------
-- 实现船体初始化

-- 实现船体移动
local function GetHeight(p,x,y)
    local pos = {p,p,p,p}
    -- for 
    -- pos[0] = pos.x + x
    -- pos[1] = pos.x - x
    -- pos[2] = pos.y + y
    -- pos[3] = p.y - y
    -- local model_pos
    -- for i in pairs(pos) do
        
    -- end
end
local function Move()
    -- 实现水平方向移动
    -- 实现垂直方向移动
    local pos = cs.transform.position
    GetHeight(pos,1,2)
end
-- 实现战斗发起
local function RequireFight()
end