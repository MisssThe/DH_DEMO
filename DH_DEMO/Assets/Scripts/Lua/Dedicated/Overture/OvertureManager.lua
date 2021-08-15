--require("Assets/Scripts/Lua/SourceManager")


-- 所有状态
local Circuit = {
    "CardsFalling",
    'CardsFallFin',
    "BeginningUI"
}
local overtureFunc = {}
local overtureMaskAnimator = overtureMask.gameObject:GetComponent(typeof(UE.Animator))

-- NetWork相关 -------------------
-- CS.NetWork.Init()
-- CS.NetWork.SendRegister("NAME", "******")
---------------------------------


-- 卡片开始落下
function overtureFunc.CardFalling()
    cardsFalling:SetActive(true)
    ExEES.DeleteType("CardsFalling")
end

-- 卡片结束落下
function overtureFunc.CardFallfin()
    sea.gameObject:GetComponent(typeof(UE.MeshRenderer)).material:SetFloat("_FogAlpha", 0)
    cameraInLoading.gameObject:GetComponent(typeof(UE.Camera)).cullingMask = 33554432
end

-- 删除卡片
function overtureFunc.CardFallDest()
    cameraInLoading:SetActive(false)
    UE.GameObject.Destroy(cameraInLoading)
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