local AAS = {}

setmetatable(AAS, CS.UnityEngine.AddressableAsset.Addressables)

-- 同步加载材质
AAS.LoadMaterialSync = CS.AddressableManager.LoadMaterialSync