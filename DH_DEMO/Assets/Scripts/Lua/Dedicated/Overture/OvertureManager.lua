--require("Assets/Scripts/Lua/SourceManager")


-- 所有状态
local Circuit = {
    "CardsFalling",
    'CardsFallFin',
    "BeginningUI"
}
local overtureFunc = {}
local overtureMaskAnimator = overtureMask.gameObject:GetComponent(typeof(UE.Animator))


-- 卡片开始落下
function overtureFunc.CardFalling()
    cardsFalling:SetActive(true)
    ExEES.DeleteType("CardsFalling")
end

-- 卡片结束落下
function overtureFunc.CardFallfin()
    quad:SetActive(false)
end

-- 删除卡片
function overtureFunc.CardFallDest()
    cameraInLoading:SetActive(false)
    
end

-- 注册页面逻辑
local hadLoadLogin = false
local loginAnimator = {}
function overtureFunc.Login()
    if not hadLoadLogin then
        ASS.InstantiateAsync("Overture/LoginPages")
        overtureMaskAnimator:SetBool("Hidden", true)
    else
        loginAnimator:SetTrigger("Show")
        overtureMaskAnimator:SetBool("Hidden", true)
    end
end
function overtureFunc.ReciveLogin(trans, animator)
    trans:SetParent(canvas.transform, false)
    animator:SetTrigger("Show")
    loginAnimator = animator
    hadLoadLogin = true
end
function overtureFunc.ComebackToMain()
    overtureMaskAnimator:SetBool("Hidden", false)
end

-- 注册事件
ExEES.Add(ExEES.Event:New("CardsFalling", overtureFunc.CardFalling, "OvertureManager"))
ExEES.Add(ExEES.Event:New('CardsFallFin', overtureFunc.CardFallfin, "OvertureManager"))
ExEES.Add(ExEES.Event:New('CardsFallDestroy', overtureFunc.CardFallDest, "OvertureManager"))
ExEES.Add(ExEES.Event:New('pushLogin', overtureFunc.Login, "OvertureManager"))
ExEES.Add(ExEES.Event:New('ReciveLogin', overtureFunc.ReciveLogin, "OvertureManager"))
ExEES.Add(ExEES.Event:New('backMain', overtureFunc.ComebackToMain, "OvertureManager"))

function OnDestroy()
    ExEES.DeleteInst("OvertureManager")
end