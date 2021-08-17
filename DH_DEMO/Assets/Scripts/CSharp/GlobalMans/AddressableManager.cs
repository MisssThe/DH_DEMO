using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.ResourceManagement.ResourceProviders;
using XLua;

[LuaCallCSharp]
public static class ExASS
{
    [LuaCallCSharp]
    public static Material LoadMaterialSync(string PrimaryKey)
    {
        var matOpt = Addressables.LoadAssetAsync<Material>(PrimaryKey);
        matOpt.WaitForCompletion();
        return matOpt.Result;
    }

    [LuaCallCSharp]
    public static void LoadSceneAsync(string sceneKey)
    {
        var sceneOpt = Addressables.LoadSceneAsync(sceneKey);
        sceneOpt.Completed += LoadSceneCompleted;
    }
    private static void LoadSceneCompleted(AsyncOperationHandle<SceneInstance> optHendle)
    {
        // 场景加载完毕并发送场景加载完毕的消息
        EventManager.Instance.Send($"0 'SceneLoadCompleted' {optHendle.Result.Scene.name}");
    }
}
