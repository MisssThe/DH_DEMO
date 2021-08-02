Manager = {}

Manager.__index = Manager;

function Manager:New()
    print("start new Manager")
    local temp = {}
    setmetatable(temp,Manager)
    print("Finish new Manager")
    return temp
end

function Manager:Awake()
    --[[
        添加所有的awake
    ]]
end

function Manager:Start()
    --[[
        添加所有的Start
    ]]
end

function Manager:FixUpdate()
    --[[
        添加所有的FixUpdate
    ]]
end

function Manager:Update()
    --[[
        添加所有的Update
    ]]
end

function Manager:LateUpdate()
    --[[
        添加所有的LastUpdate
    ]]
end

function Manager:OnDestroy()
    --[[
        添加所有的OnDestroy
    ]]
end

local lua_manager = Manager:New()

function Awake()
    lua_manager:Awake()
end

function Start()
    lua_manager:Start()
end

function FixUpdate()
    lua_manager:FixUpdate()
end

function Update()
    lua_manager:Update()
end

function LateUpdate()
    lua_manager:LateUpdate()
end

function OnDestroy()
    lua_manager:OnDestroy()
end