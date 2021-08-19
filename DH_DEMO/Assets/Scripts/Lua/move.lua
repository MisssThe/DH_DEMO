--require "ship.lua"
--require ("Assets/Scripts/Lua/UIManager.lua")
local UE = CS.UnityEngine
local speed_x 
local speed_y 
local max_speed 
local transform 
local camera
local camera_transform
local boat_x
local boat_y
local mouse_x
local mouse_y
local ship
Global.go_name = nil


function MyRotateAround(center,axis,angle)
    pos = camera_transform.position
    rot = UE.Quaternion.AngleAxis(angle,axis)
    dir = pos - center
    dir = rot*dir

    target_angle = camera_transform.rotation.eulerAngles
    if (target_angle.x<=10 and angle<0) or (target_angle.x>30 and angle>0)then
        return
    end

    camera_transform.position = center+dir
    myrot = camera_transform.rotation
    camera_transform.rotation = rot*myrot

    
end

function Move()
    boat_x = UE.Input.GetAxis("Horizontal")
    boat_y = UE.Input.GetAxis("Vertical")

    speed_y = UE.Mathf.Lerp(speed_y,boat_y*max_speed,0.7*UE.Time.deltaTime)

    if(UE.Mathf.Abs( speed_y ) < 0.01) then
        speed_y = 0
    end

    speed_y = UE.Mathf.Clamp(speed_y,-max_speed,max_speed)

    temp_y = transform.rotation.eulerAngles.y + boat_x * 30 * UE.Time.deltaTime
    target_angle = transform.rotation.eulerAngles
    target_angle.y = temp_y

    -- if(boat_x ~= 0 or boat_y ~= 0) then
    --     CS.NetWork.SendMyAttribute(transform.name,transform.position.x,transform.position.z,transform.rotation.y)
    -- end
    transform.rotation = UE.Quaternion.Euler(target_angle)
    transform:Translate(UE.Vector3.forward * speed_y * UE.Time.deltaTime)
end

function CameraLook()
    mouse_x = UE.Input.GetAxis("Mouse X")
    mouse_y = UE.Input.GetAxis("Mouse Y")

    camera_transform:RotateAround(transform.position, transform.up, mouse_x * 150 * UE.Time.deltaTime)
    MyRotateAround(transform.position, camera_transform.right, -mouse_y * 150 * UE.Time.deltaTime)
end

function MouseHit()
    mouse_left = UE.Input.GetMouseButtonDown(0)
    if mouse_left then
        ray = UE.Camera.main:ScreenPointToRay(UE.Input.mousePosition)
        go = CS.Tools.MouseRaycast()--获得点击的物体Gameobject
        if go ~= nil then


            --弹出对战邀请框？
            if go.tag == "UserShip" then
                UIManager.OpenUI("StartFight(Clone)")
                go_name = go.name
                FightSystem.player_info.rivial_name = go.name
                print("点击")
                -- CS.NetWork.SendToFight("222",go_name)
            end
            
        end
    end
end

function Awake()
    speed_y = 0
    max_speed = 5
    transform = cs_self.transform
    transform.position = UE.Vector3(-36,-18.4,120)
    transform.rotation = UE.Quaternion.Euler(UE.Vector3(0,51,0))
    transform.name = CS.NetWork.GetPlayerName()
    FightSystem.player_info.self_name = transform.name
    camera = transform:Find("Main Camera")
    camera_transform = camera.transform
    --ship = Ship:new("user",0,0,0)
end

function Update()
    Move()
    --CameraLook()
    MouseHit()
end
