UE = CS.UnityEngine
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
function Awake()
    speed_y = 0
    max_speed = 5
    transform = cs_self.transform
    camera = transform:Find("Main Camera")
    camera_transform = camera.transform
end
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
function Update()
    boat_x = UE.Input.GetAxis("Horizontal")
    boat_y = UE.Input.GetAxis("Vertical")
    
    mouse_x = UE.Input.GetAxis("Mouse X")
    mouse_y = UE.Input.GetAxis("Mouse Y")


    speed_y = UE.Mathf.Lerp(speed_y,boat_y*max_speed,0.7*UE.Time.deltaTime)
    
    if(UE.Mathf.Abs( speed_y ) < 0.01) then
        speed_y = 0
    end


    speed_y = UE.Mathf.Clamp(speed_y,-max_speed,max_speed)


    temp_y = transform.rotation.eulerAngles.y + boat_x * 30 * UE.Time.deltaTime
    target_angle = transform.rotation.eulerAngles
    target_angle.y = temp_y

    transform.rotation = UE.Quaternion.Euler(target_angle)
    transform:Translate(UE.Vector3.forward * speed_y * UE.Time.deltaTime)
    camera_transform:RotateAround(transform.position, transform.up, mouse_x * 150 * UE.Time.deltaTime)
    MyRotateAround(transform.position, camera_transform.right, -mouse_y * 150 * UE.Time.deltaTime)
    --target_angle = camera_transform.rotation.eulerAngles
    --camera_transform:RotateAround(transform.position, camera_transform.right, -mouse_y * 150 * UE.Time.deltaTime)

    
    --[[target_angle = camera_transform.rotation.eulerAngles
    target_angle.x = UE.Mathf.Clamp(target_angle.x,10,30)
    camera_transform.rotation = UE.Quaternion.Euler(target_angle)--]]
end
