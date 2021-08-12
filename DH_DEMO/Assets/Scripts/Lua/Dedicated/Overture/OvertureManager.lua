-- 所有状态
local Circuit = {
    "CardsFalling",
    "BeginningUI"
}
local overtureFunc = {}
-- 当前状态
local precentCircuit = {}
local cameraInLoading = {}
local cardsFalling = {}
local waitTime = 0

function overtureFunc.CardFalling()
    print("cardfalled")
    EES.DeleteType("CardsFalling")
end

local event = EES.Event:New(nil, "overtureManager", false, "CardsFalling", overtureFunc.CardFalling)
EES.Add(event)