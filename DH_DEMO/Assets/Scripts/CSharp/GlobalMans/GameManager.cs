using System;
using System.Collections.Generic;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine;
using System.Threading.Tasks;

/// <summary>
/// 游戏管理器
/// </summary>
public class GameManager : MonoBehaviour
{
    public bool HadInit { private set; get; } = false; 

    static private GameManager inst = null;
    /// <summary>
    /// 实例
    /// </summary>
    static public GameManager Instance { 
        get 
        {
            if (inst != null)
                return inst;
            else
                throw new ApplicationException("没有声明游戏管理器实例！");
        } 
    }

    private async Task UpdateCheck()
    {
        var catalogsOpt = Addressables.CheckForCatalogUpdates();
        await catalogsOpt.Task;

        if (catalogsOpt.Status == AsyncOperationStatus.Succeeded)
        {
            var catalogs = catalogsOpt.Result;
            if (catalogs != null && catalogs.Count > 0)
            {
                var catalogOpt = Addressables.UpdateCatalogs(catalogs, false);
                await catalogOpt.Task;
                foreach (var item in catalogOpt.Result)
                {
                    foreach (var key in item.Keys)
                    {
                        if (key != null && (string)key != "" && await Addressables.GetDownloadSizeAsync(key).Task != 0)
                        {
                            await Addressables.DownloadDependenciesAsync(key).Task;
                        }
                    }
                }
            }
        }
    }

    /// <summary>
    /// 游戏程序初始化
    /// </summary>
    private async void Init()
    {
        HadInit = false;

        // 初始化
        await UpdateCheck();

        HadInit = true;
    }

    void Awake()
    {
        if(inst == null)
        {
            inst = this;
            DontDestroyOnLoad(gameObject);
            Init();
        }
        else
            Destroy(gameObject);
    }
}
