require("Assets/Scripts/Lua/UI/UIView.lua")

local animator = cs_self.gameObject:GetComponent(typeof(UE.Animator))
local usernameSave = ""

-- 注册或登录页面
CS.NetWork.Init()
ExEES.Send('ReciveLogin', "OvertureManager", cs_self.transform, animator)
local faillog = failedLog.gameObject:GetComponent(typeof(UE.UI.Text))
local pw = password.gameObject:GetComponent(typeof(UE.UI.InputField))
local un = username.gameObject:GetComponent(typeof(UE.UI.InputField))
local loginwait = loginWaiting.gameObject:GetComponent(typeof(UE.UI.Text))

-- 进出登录界面
ExEES.Add(ExEES.Event:New("In", function(TRIGGLE) 
    animator:SetTrigger(TRIGGLE) 
end, "loginpage"))
ExEES.Add(ExEES.Event:New("Out", function()
    animator:SetTrigger('Hidden')
    ExEES.Send('backMain', "OvertureManager")
end, "loginpage"))

-- 登录按钮
ExEES.Add(ExEES.Event:New("Login", function()
    faillog.color = UE.Color(1, 0, 0, 1)
    if faillog.isActiveAndEnabled then
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
        CS.NetWork.SendLogIn(un.text, pw.text)
        animator:SetBool("LoginWaiting", true)
        usernameSave = un.text
    end

end, "loginpage"))

-- 注册按钮
ExEES.Add(ExEES.Event:New("Register", function()
    faillog.color = UE.Color(1, 0, 0, 1)
    if faillog.isActiveAndEnabled then
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
        CS.NetWork.SendRegister(un.text, pw.text)
        animator:SetBool("LoginWaiting", true)
    end
end, "loginpage"))

-- 接受消息的处理
ExEES.Add(ExEES.Event:New("loginRecive", function(reciveInfo)
    if reciveInfo == 1 then
        faillog.color = UE.Color(1, 0, 0, 1)
        faillog.gameObject:SetActive(true)
        faillog.text = "该用户名已存在"
        if animator ~= nil and animator.SetBool ~= nil then
            animator:SetBool("LoginWaiting", false)
        end
    elseif reciveInfo == 2 then
        faillog.color = UE.Color(0.5, 0.6, 1, 1)
        faillog.gameObject:SetActive(true)
        faillog.text = "注册成功! ! !"
        if animator ~= nil and animator.SetBool ~= nil then
            animator:SetBool("LoginWaiting", false)
        end
    elseif reciveInfo == 3 then
        faillog.color = UE.Color(1, 0, 0, 1)
        faillog.gameObject:SetActive(true)
        faillog.text = "用户名或密码错误"
        if animator ~= nil and animator.SetBool ~= nil then
            animator:SetBool("LoginWaiting", false)
        end
    elseif reciveInfo == 4 then
        faillog.color = UE.Color(1, 0, 0, 1)
        faillog.gameObject:SetActive(true)
        faillog.text = "用户名或密码错误"
        if animator ~= nil and animator.SetBool ~= nil then
            animator:SetBool("LoginWaiting", false)
        end
    elseif reciveInfo == 5 then
        ExEES.Send('hadLogin', "OvertureManager")
        if animator ~= nil and animator.SetBool ~= nil then
            animator:SetBool("LoginWaiting", false)
            animator:SetTrigger('Hidden')
            ExEES.Send('backMain', "OvertureManager")
            CS.NetWork.SetPlayerName(usernameSave)
        end
    end
end, "loginpage"))

-- 显示消息
ExEES.Add(ExEES.Event:New("showInfo", function(info, col)
    faillog.gameObject:SetActive(true)
    faillog.text = info
    if col ~= nil then
        faillog.color = col
    end
end, "loginpage"))

function OnDestroy()
    ExEES.DeleteInst("loginpage")
end