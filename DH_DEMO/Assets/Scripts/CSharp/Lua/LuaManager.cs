using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.ResourceLocations;
using XLua;

/// <summary>
/// 用来管理lua脚本，特别是全局脚本(单例)
/// 建议挂在 "GameManager" 类似的脚本下
///                     -- 20210805
/// </summary>
public sealed class LuaManager : MonoBehaviour
{
    [SerializeField]
    [Tooltip("需要载入的Lua脚本的标签")]
    private List<AssetLabelReference> luaLabels;
    [SerializeField]
    [Tooltip("在一开始就加载lua脚本")]
    private bool LoadLuaAtOnce = true;
    
    /// <summary>
    /// 轮询是否加载完成的间隔时间
    /// </summary>
    public const int DelayTime = 10;
    /// <summary>
    /// 垃圾回收的间隔时间
    /// </summary>
    private const float GCInterval = 10;

    /// <summary>
    /// 存放着所有的局部lua脚本
    /// <key> lua脚本的资源地址 </key>
    /// <value> lua脚本类本身 </value>
    /// </summary>
    private readonly Dictionary<string, HashSet<ILuaScript>> _luaLocals = new Dictionary<string, HashSet<ILuaScript>>();
    /// <summary>
    /// 存放所有lua资产
    /// </summary>
    private readonly Dictionary<string, (byte[] data, string label)> _luaAssets 
        = new Dictionary<string, (byte[] data, string label)>();
    /// <summary>
    /// 全局的lua环境
    /// </summary>
    private LuaEnv _luaEnv;
    /// <summary>
    /// 脚本加载完成度
    /// </summary>
    private float _percentProcess = 0.0f;
    /// <summary>
    /// 是否正在读取代码
    /// </summary>
    private bool _isLoading;
    /// <summary>
    /// 实例
    /// </summary>
    private static LuaManager _inst;
    /// <summary>
    /// 上一次垃圾清理的时间
    /// </summary>
    private static float _lastGCTime = 0;

    /// <summary>
    /// 实例访问器
    /// </summary>
    public static LuaManager Instance { get { return _inst; } }
    /// <summary>
    /// 是否没有载入完成代码
    /// </summary>
    public bool IsLoading
    {
        get { return _isLoading; }
    }
    /// <summary>
    /// 载入进度
    /// </summary>
    public float PrecentProcess
    {
        get { return _percentProcess; }
    }
    /// <summary>
    /// 全局 Lua 环境
    /// </summary>
    public LuaEnv Env { get { return _luaEnv; } }

    #region 自建函数
    /// <summary>
    /// 刷新游戏
    /// </summary>
    public void RestartGame()
    {
        _luaEnv.DoString("require(\"framework.App\").restartGame()", "restart game");
        foreach (var luaScr in _luaLocals)
        {
            foreach (var lualocal in luaScr.Value) lualocal.Restart();
        }
    }
    #region 与 ILuaScript 通信
    /// <summary>
    /// 注册Lua脚本到管理器
    /// </summary>
    /// <param name="luaScript"> Lua脚本 </param>
    public async Task AddLuaScript(ILuaScript luaScript)
    {
        while (_isLoading) { await Task.Delay(DelayTime); }
        
        luaScript.CreateEnv(this);
        var key = luaScript.Key;
        if (_luaAssets.ContainsKey(key))
        {
            // 生成局部环境
            LuaTable metatable = _luaEnv.NewTable();
            metatable.Set("__index", _luaEnv.Global);
            luaScript.Local.SetMetaTable(metatable);
            metatable.Dispose();

            luaScript.SetObjsToLua(this);
            
            _luaEnv.DoString(AddressableLoader(ref key),
                luaScript.Key + luaScript.GetHashCode().ToString(),
                luaScript.Local);
        }
#if UNITY_EDITOR
        else
        {
            Debug.LogError("指定脚本未注册，或者是否忘了载入脚本？");
        }
#else
        else
        {
            return;
        }
#endif

        if (_luaLocals.ContainsKey(luaScript.Key))
        {
            if (_luaLocals[luaScript.Key].Contains(luaScript))
            {
                Debug.LogWarning("不要重复载入Lua脚本！！");
            }
        }
        else
        {
            _luaLocals[luaScript.Key] = new HashSet<ILuaScript>();
        }
        _luaLocals[luaScript.Key].Add(luaScript);
    }
    /// <summary>
    /// 注销Lua脚本从管理器
    /// </summary>
    /// <param name="luaScript"> Lua脚本 </param>
    public void SubLuaScript(ILuaScript luaScript)
    {
        if (_luaLocals.ContainsKey(luaScript.Key))
        {
            if (_luaLocals[luaScript.Key].Contains(luaScript))
            {
                _luaLocals[luaScript.Key].Remove(luaScript);
            }
            else
            {
                Debug.LogWarning("是否重复删除了脚本？");
            }
        }
    }
    #endregion
    #region 脚本的加载/卸载和刷新
    /// <summary>
    /// 清空并重新载入所有设定标签下的 lua 脚本
    /// </summary>
    public void ReloadAll()
    {
#if UNITY_EDITOR
        Debug.Log("清空 LuaManager 所有缓存");
#endif
        _luaAssets.Clear();
        GetAllLuaAsset();
    }
    /// <summary>
    /// 根据标签增量载入/替换脚本(异步)
    /// </summary>
    /// <param name="completedDelegate"> 完成后的回调 </param>
    /// <param name="labels"> 新脚本的标签 </param>
    public async void AddLoadAsync(Action completedDelegate = null, params AssetLabelReference[] labels)
    {
        if (labels.Length < 1) return;

        _isLoading = true;
        _percentProcess = 0.0f;

        float labelCount = labels.Length;
        int idx = 0;
        foreach (var label in labels)
        {
            if (luaLabels.Any(lb => { return lb.labelString == label.labelString; }))
            {
                SubLoad(label);
            }
            await GetAddLuaAsset(label);

            idx++;
            _percentProcess = idx / labelCount;
        }

        // 加载完成
        _percentProcess = 1.0f;
        _isLoading = false;

        if (completedDelegate != null) completedDelegate.Invoke();
    }
    /// <summary>
    /// 根据标签增量载入/替换脚本(同步(不要用这个!!))
    /// </summary>
    /// <param name="labels"> 新脚本的标签 </param>
    public void AddLoad(params AssetLabelReference[] labels)
    {
        if (labels.Length < 1) return;

        _isLoading = true;
        _percentProcess = 0.0f;

        float labelCount = labels.Length;
        int idx = 0;
        foreach (var label in labels)
        {
            if (luaLabels.Any(lb => { return lb.labelString == label.labelString; }))
            {
                SubLoad(label);
            }

            var locationsOpt = Addressables.LoadResourceLocationsAsync(label);
            locationsOpt.WaitForCompletion();
            var locations = locationsOpt.Result;
            foreach (var location in locations)
            {
                if (location.ResourceType == typeof(LuaAsset))
                {
                    var assetOpt = Addressables.LoadAssetAsync<LuaAsset>(location.PrimaryKey);
                    assetOpt.WaitForCompletion();
                    var asset = assetOpt.Result;
                    _luaAssets[location.PrimaryKey] =
                        asset.encode ?
                        (asset.GetDecodeBytes(), label.labelString) : (asset.data, label.labelString);
                }
                else if (location.ResourceType == typeof(TextAsset))
                {
                    var assetOpt = Addressables.LoadAssetAsync<TextAsset>(location.PrimaryKey);
                    assetOpt.WaitForCompletion();
                    var asset = assetOpt.Result;
                    _luaAssets[location.PrimaryKey] =
                        (asset.bytes, label.labelString);
                }
            }

            idx++;
            _percentProcess = idx / labelCount;
        }

        // 加载完成
        _percentProcess = 1.0f;
        _isLoading = false;
    }
    /// <summary>
    /// 根据标签卸载脚本
    /// </summary>
    /// <param name="labels"> 要卸载的标签 </param>
    public void SubLoad(params AssetLabelReference[] labels)
    {
        if (labels.Length < 1) return;
        var luaScrKey = new LinkedList<string>();
        // 获得所有需要被删除的 Lua 代码索引
        foreach (var label in labels)
        {
            foreach (var luaScr in _luaAssets)
            {
                if (luaScr.Value.label == label.labelString)
                {
                    luaScrKey.AddLast(luaScr.Key);
                }
            }
        }
        // 删除 Lua 脚本和其附着的 ILuaScript
        foreach (var key in luaScrKey)
        {
            _luaAssets.Remove(key);
            if (_luaLocals.ContainsKey(key))
            {
                foreach (var luaLocal in _luaLocals[key])
                {
                    luaLocal.Destroy();
                }
                _luaLocals[key].Clear();
            }
            _luaLocals.Remove(key);
        }
    }
    /// <summary>
    /// 根据标签异步地增量加载脚本(对于单个标签而言)
    /// </summary>
    /// <param name="label"> 增量加载脚本的标签 </param>
    /// <returns> task </returns>
    private async Task GetAddLuaAsset(AssetLabelReference label)
    {
        var locations = await Addressables.LoadResourceLocationsAsync(label).Task;
        foreach (var location in locations)
        {
            if (location.ResourceType == typeof(LuaAsset))
            {
                var asset = await Addressables.LoadAssetAsync<LuaAsset>(location.PrimaryKey).Task;
                _luaAssets[location.PrimaryKey] =
                    asset.encode ?
                    (asset.GetDecodeBytes(), label.labelString) : (asset.data, label.labelString);
            }
            else if (location.ResourceType == typeof(TextAsset))
            {
                _luaAssets[location.PrimaryKey] =
                    ((await Addressables.LoadAssetAsync<TextAsset>(location.PrimaryKey).Task).bytes, label.labelString);
            }
        }
    }
    /// <summary>
    /// 异步地载入所有Lua脚本的索引
    /// </summary>
    private async void GetAllLuaAsset()
    {
        _isLoading = true;
        _percentProcess = 0.0f;
        var locationss = new LinkedList<(IResourceLocation loc, string label)>();
        foreach (var luaLabel in luaLabels)
        {
            var locations = await Addressables.LoadResourceLocationsAsync(luaLabel).Task;
            foreach (var location in locations)
                locationss.AddLast((location, luaLabel.labelString));
        }

        float locationCount = locationss.Count;

#if UNITY_EDITOR
        if (locationss.Count == 0)
            throw new ApplicationException("该标签下没有找到任何资源。");
#endif

        var idx = 0;
        foreach (var location in locationss)
        {
            if(_luaAssets.ContainsKey(location.loc.PrimaryKey)) continue;
            if (location.loc.ResourceType == typeof(LuaAsset))
            {
                var asset = await Addressables.LoadAssetAsync<LuaAsset>(location.loc.PrimaryKey).Task;
                _luaAssets[location.loc.PrimaryKey] = 
                    asset.encode ?
                    (asset.GetDecodeBytes(), location.label) : (asset.data, location.label);
            }
            else if (location.loc.ResourceType == typeof(TextAsset))
            {
                _luaAssets[location.loc.PrimaryKey] =
                    ((await Addressables.LoadAssetAsync<TextAsset>(location.loc.PrimaryKey).Task).bytes, location.label); 
            }

            idx++;
            _percentProcess = idx / locationCount;
        }

#if UNITY_EDITOR
        if (_luaAssets.Count == 0)
            throw new ApplicationException("该标签下没有找到Lua脚本。");
#endif

        InitLua();

        // 加载完成
        _percentProcess = 1.0f;
        _isLoading = false;
    }
    /// <summary>
    /// 自定义 AddressableLuaLoader
    /// </summary>
    /// <param name="path"> require地址 </param>
    /// <returns> LuaByteCode </returns>
    private byte[] AddressableLoader(ref string path)
    {
        return _luaAssets.ContainsKey(path) ? _luaAssets[path].data : null;
    }
    /// <summary>
    /// 初始化全局脚本
    /// </summary>
    private void InitLua()
    {
        //方便切换任意场景 执行一次lua初始化
        _luaEnv.DoString("require(\"framework.App\").init()", "lua init");
    }
    #endregion
    #endregion

    #region U3D内建函数
    void Awake()
    {
        if (Instance == null)
        {
            _inst = this;
            _luaEnv = new LuaEnv();
            _luaEnv.AddLoader(AddressableLoader);
        }
        else
            Destroy(gameObject);
        if (LoadLuaAtOnce) GetAllLuaAsset();
    }
    void Update()
    {
        // 间隔固定的时间进行垃圾清理
        if (_luaEnv != null && Time.time - _lastGCTime > GCInterval)
        {
            _luaEnv.Tick();
            _lastGCTime = Time.time;
        }
    }
    #endregion
}
