using System.Threading.Tasks;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using Object = System.Object;

/// <summary>
/// Lua 脚本的本地环境接口
/// </summary>
public interface ILuaScript
{
    /// <summary>
    /// 是否还在加载
    /// </summary>
    bool IsBuilding { get; }
    /// <summary>
    /// Lua 的本地环境
    /// </summary>
    LuaTable Local { get; }
    /// <summary>
    /// Lua 脚本的资源索引
    /// </summary>
    string Key { set; get; }

    /// <summary>
    /// 重载脚本
    /// </summary>
    void Restart();
    /// <summary>
    /// 卸载脚本(这里通常写成异步的)
    /// </summary>
    void Destroy();

    // --------------------------------不建议在 LuaManager 外使用的函数
    /// <summary>
    /// 创建环境
    /// </summary>
    /// <param name="luaMan"> Lua 管理器(单例) </param>
    void CreateEnv(LuaManager luaMan);
    /// <summary>
    /// 修改状态(不对外使用)
    /// </summary>
    /// <param name="state"> 目标状态 </param>
    void SetBuildingState(bool state);
    /// <summary>
    /// 传递对象到 Lua 中(不对外使用)
    /// </summary>
    /// <param name="luaMan"> Lua 管理器(单例) </param>
    void SetObjsToLua(LuaManager luaMan);
}

/// <summary>
/// Lua脚本本地环境
/// </summary>
public sealed class LuaScript : ILuaScript
{
    private bool _isBuilding;
    private LuaTable _local;
    private string _key;
    private Dictionary<string, Object> _objectsToLuaCache;

    public LuaTable Local
    {
        get { return _local; }
    }
    public string Key
    {
        set { _key = value; }
        get { return _key; }
    }
    public bool IsBuilding
    {
        get { return _isBuilding; }
    }

    /// <summary>
    /// 新载入脚本
    /// </summary>
    /// <param name="scriptPath"> Lua 脚本资源地址 </param>
    /// <param name="objectsToLua"> 要传到 Lua 环境中的对象们 </param>
    public LuaScript(string scriptPath, Dictionary<string, Object> objectsToLua = null)
    {
        if (objectsToLua != null)
            _objectsToLuaCache = new Dictionary<string, Object>(objectsToLua);
        _isBuilding = true;
        var task = LuaManager.Instance.AddLuaScript(this);
    }

    #region 继承于ILuaScript
    public void Restart()
    {
        Destroy();
        var task = LuaManager.Instance.AddLuaScript(this);
    }
    public async void Destroy()
    {
        while (_isBuilding) { await Task.Delay(LuaManager.DelayTime); }

        if (_local != null)
        {
            _local.Dispose();
            _local = null;
        }
    }
    public void CreateEnv(LuaManager luaMan)
    {
        if (_local != null)
        {
            _local.Dispose();
            _local = null;
        }
        _local = luaMan.Env.NewTable();
    }
    public void SetBuildingState(bool state)
    {
        _isBuilding = state;
    }
    public void SetObjsToLua(LuaManager luaMan)
    {
        var localSet = typeof(LuaTable).GetMethod("Set");
        foreach (var obj in _objectsToLuaCache)
        {
            if (obj.Key != "" && obj.Key != null)
            {
                var preMethod = localSet.MakeGenericMethod(typeof(string), obj.GetType());
                preMethod.Invoke(
                        _local,
                        new object[]
                        {
                        obj.Key, obj.Value
                        });
            }
            else
            {
#if UNITY_EDITOR
                Debug.LogError("不能以空值为参数名");
#endif
                var preMethod = localSet.MakeGenericMethod(typeof(string), obj.GetType());
                preMethod.Invoke(
                        _local,
                        new object[]
                        {
                        obj.Value.GetHashCode().ToString(), obj.Value
                        });
            }
        }
        _objectsToLuaCache.Clear();
    }
    #endregion
}
