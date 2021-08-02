using System;
using System.Timers;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.AddressableAssets.ResourceLocators;
using UnityEngine.ResourceManagement.AsyncOperations;

/// <summary>
/// 资产管理(对Addressable的进一步封装)
/// </summary>
public class AssetManager
{
    /// <summary>
    /// 等待同步加载的游戏物体
    /// </summary>
    private GameObject[] _gameObjectWaitting;
    /// <summary>
    /// 计数
    /// </summary>
    int count = 0;
    /// <summary>
    /// 
    /// </summary>
    float pre_time = 0;
    /// <summary>
    /// 根据索引来获取资产(同步)
    /// </summary>
    /// <param name="keys"> 索引 </param>
    /// <param name="time"> 愿意等待的最大秒数 </param>
    /// <returns> 资产列表 </returns>
    public GameObject[] LoadAsset(string[] keys, float time = -1)
    {
        Guid guid = Guid.NewGuid();     // 当前批次的Guid
        this._gameObjectWaitting = new GameObject[keys.Length];
        this.count = keys.Length;

        this.pre_time = Time.realtimeSinceStartup;
        for (int idx = 0; idx < keys.Length; idx++)
        {
            var obj = Addressables.InstantiateAsync("asset_reference");
            obj.Completed += HadCompleted;
        }
        while(count > 0)
        {
            if(time > 0 && Time.realtimeSinceStartup - pre_time > time)
            {
                return null;
            }
        }

        var o = _gameObjectWaitting;
        this._gameObjectWaitting = null;
        return o;
    }

    /// <summary>
    /// 完成时的
    /// </summary>
    /// <param name="obj"></param>
    private void HadCompleted(AsyncOperationHandle<GameObject> obj)
    {
        count--;
    }
}
