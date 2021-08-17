
-- 动画器
print("游戏开始啦！")
local animator = cs_self.gameObject:GetComponent(typeof(UE.Animator))
local loadingScene = ""
local sceneTran = ""

-- 场景转换的脚本
ExEES.Add(ExEES.Event:New('SceneLoad', function(sceneKey, sceneT)

    if sceneT ~= "ColorField" then
        sceneTran = "WaveLoading"
    else
        sceneTran = "BlackFieldLoading"
    end

    animator:SetBool(sceneTran, true)
    loadingScene = sceneKey
end, "SceneTran"))

ExEES.Add(ExEES.Event:New('SceneLoadingStart', function()
    if loadingScene == nil or loadingScene == "" then
        animator:SetBool(sceneTran, false)
    else
        CS.ExASS.LoadSceneAsync(loadingScene)
    end
    
end, "SceneTran"))

ExEES.Add(ExEES.Event:New('SceneLoadCompleted', function()
    animator:SetBool(sceneTran, false)
    sceneTran = ""
end, "SceneTran"))

function OnDestroy()
    ExEES.DeleteInst("SceneTran")
end