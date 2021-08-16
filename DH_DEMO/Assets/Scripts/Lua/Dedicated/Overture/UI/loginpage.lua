require("Assets/Scripts/Lua/UI/UIView.lua")

local animator = cs_self.gameObject:GetComponent(typeof(UE.Animator))

-- 注册或登录页面
ExEES.Send('ReciveLogin', "OvertureManager", cs_self.transform, animator)
local faillog = failedLog.gameObject:GetComponent(typeof(UE.UI.Text))
local pw = password.gameObject:GetComponent(typeof(UE.UI.InputField))
local un = username.gameObject:GetComponent(typeof(UE.UI.InputField))
local loginwait = loginWaiting.gameObject:GetComponent(typeof(UE.UI.Text))

-- 进出登录界面
ExEES.Add(ExEES.Event:New("In", function(TRIGGLE) animator:SetTrigger(TRIGGLE) end, "loginpage"))
ExEES.Add(ExEES.Event:New("Out", function()
    animator:SetTrigger('Hidden')
    ExEES.Send('backMain', "OvertureManager")
end, "loginpage"))

-- 登录按钮
ExEES.Add(ExEES.Event:New("Login", function()
    if faillog.IsActive then
        faillog.gameObject:SetActive(false)
    end
    if un.text == "" or un.text == nil then
        faillog.gameObject:SetActive(true)
        faillog.text = "请先输入用户名"
    elseif pw.text == "" or pw == nil then
        faillog.gameObject:SetActive(true)
        faillog.text = "请先输入密码"
    else
        loginwait.text = "登录中"
        animator:SetBool("LoginWaiting", true)
    end
end, "loginpage"))

-- 注册按钮
ExEES.Add(ExEES.Event:New("Register", function()
    if faillog.IsActive then
        faillog.gameObject:SetActive(false)
    end
    if un.text == "" or un.text == nil then
        faillog.gameObject:SetActive(true)
        faillog.text = "请先输入用户名"
    elseif pw.text == "" or pw == nil then
        faillog.gameObject:SetActive(true)
        faillog.text = "请先输入密码"
    else
        loginwait.text = "注册中"
        animator:SetBool("LoginWaiting", true)
    end
end, "loginpage"))

-- 接受消息的处理
ExEES.Add(ExEES.Event:New("loginRecive", function(reciveInfo)
    if reciveInfo == "登录成功" then
        
    end
end, "loginpage"))

function OnDestroy()
    ExEES.DeleteInst("loginpage")
end