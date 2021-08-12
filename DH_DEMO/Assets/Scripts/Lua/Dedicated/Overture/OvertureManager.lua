-- 所有状态
local Circuit = {
    "CardsFalling",
    'CardsFallFin',
    "BeginningUI"
}
local overtureFunc = {}
-- 当前状态
local precentCircuit = {}
local waitTime = 0

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

-- 注册事件
local event = ExEES.Event:New(nil, "OvertureManager", false, "CardsFalling", overtureFunc.CardFalling)
ExEES.Add(event)
local event2 = ExEES.Event:New(nil, "OvertureManager", false, 'CardsFallFin', overtureFunc.CardFallfin)
ExEES.Add(event2)
local event3 = ExEES.Event:New(nil, "OvertureManager", false, 'CardsFallDestroy', overtureFunc.CardFallDest)
ExEES.Add(event3)

-- 检查
function Update()
    
end
