require "Assets\\Scripts\\Lua\\EventSystem"
local transform
local user_name
local password
local socket

function Click()
    user_name = transform:Find("UserName_Input"):Find("Text"):GetComponent("Text").text
    password = transform:Find("PassWord_Input"):Find("Text"):GetComponent("Text").text
    print(user_name)
    print(password)
    CS.NetWork.Init()
    EventSystem.Add("register",false,CS.NetWork.SendRegister)
    EventSystem.Send("register",user_name,password)
    --CS.NetWork.SendRegister(user_name,password)
    -- cast(CS.System.Text.Encoding.ASCII, typeof(CS.System.Text.Encoding))
    -- socket:Send(CS.System.Text.Encoding.ASCII:GetBytes(user_name))
    -- socket:Send(CS.System.Text.Encoding.ASCII:GetBytes(password))
end

function Awake()
    transform = self.transform
    -- socket = CS.NetWork.GetConnect()
    transform:Find("Register_Button"):GetComponent("Button").onClick:AddListener(Click)
end

