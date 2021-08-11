-- 这是关于开始动画和开始界面的管理器
require("Assets/Scripts/Lua/EventSystem.lua")

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
    cardsFalling:SetActive(true)
end

print (a)
EES.Add("CardsFalling", false, overtureFunc.CardFalling)