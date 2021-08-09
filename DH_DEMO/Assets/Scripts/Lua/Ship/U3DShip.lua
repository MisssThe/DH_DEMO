require("Assets/Scripts/Lua/Ship/Ship.lua")
----------------------------------- 生命周期 --------------------------------
local ship

function Awake()
    if (cs_self ~= nil) then
        ship = Ship:New()
    end
end
function Start()
end
function Update()
end
function FixedUpdate()
end
function LateUpdate()
end
function OnDestroy()
    print("destroy object")
end