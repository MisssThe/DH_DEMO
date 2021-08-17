require("Assets/Scripts/Lua/SourceManager")

print("开始加载场景物体")
---------------------------------- 先加载全局物体 ----------------------------------
print("开始加载全局物体")
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/UICamera.prefab")
-- 加载卡牌集
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/CardsControl.prefab")
-- 加载Canvas
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/Canvas.prefab")
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/EventSystem.prefab")
-- 加载商店系统
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/StoreSystem.prefab")
-- 加载背包系统
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/BagSystem.prefab")
-- 加载战斗系统
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/FightSystem.prefab")
-- ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/FightSence.prefab")
---------------------------------- 在加载局部物体 ----------------------------------
print("开始加载局部物体")
-- 加载场景地图
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/MainMap.prefab")
-- 加载玩家
ASS.InstantiateAsync("Assets/ExternalResources/Prefabs/Ship.prefab")