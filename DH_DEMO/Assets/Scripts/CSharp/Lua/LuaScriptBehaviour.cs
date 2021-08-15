using System;
using System.Reflection;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.AddressableAssets;
using XLua;

/// <summary>
///  <para> 能够挂在在物体上的Lua脚本本地环境 </para>
///  <para> 继承后的 void Awake() 函数中记得加上 base.Awake()! </para>
///  <para> 其他的 unity 内建函数也是类似的做法！ </para>
///  <para> 默认不传递CS类本身到 Lua，若有必要，请给类本身加上 [LuaObject] 注解 </para>
/// </summary>
public abstract class LuaScriptBehaviour : MonoBehaviour, ILuaScript, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    [SerializeField]
    [Tooltip("lua脚本的PrimaryKey")]
    private AssetReference luaAsset;

    [SerializeField]
    [Tooltip("需要送到Lua脚本中的物体")]
    private GameOBJ[] gameObjectsToLua;
    [Serializable]
    private class GameOBJ { public GameObject data = null; public string key = null; }

    private static ulong _luaScriptBehavioutsLodingCount = 0;
    private bool _isBuilding = true;
    private LuaTable _local = null;
    private string _key = null;

    // ---------- U3d 内建方法在 lua 中的映射 --------------
    private Action _luaStart;
    private Action _luaUpdate;
    private Action _luaFixedUpdate;
    private Action _luaLateUpdate;
    private Action _luaOnGUI;
    private Action _luaOnDisable;
    private Action _luaOnEnable;
    private Action _luaOnDestroy;
    private Action<PointerEventData> _luaOnBeginDrag;
    private Action<PointerEventData> _luaOnDrag;
    private Action<PointerEventData> _luaOnEndDrag;
    private Action<bool> _luaOnApplicationFocus;
    private Action<bool> _luaOnApplicationPause;
    // ----------------------------------------------------

    /// <summary>
    /// 是否所有的 LuaBehaviour 都加载完了
    /// </summary>
    public static bool FinishLoading
    {
        get { return _luaScriptBehavioutsLodingCount == 0; }
    }
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
    /// 重设 Lua 资源
    /// </summary>
    public AssetReference LuaAssetRef
    {
        set
        {
            luaAsset = value;
            _key = null;
            Restart();
        }
    }

    #region 自建方法
    #region 继承于ILuaScript
    public void Restart()
    {
        Destroy();
        if (_key == null) LuaBehaviourConstructor();
        else
        {
            var task = LuaManager.Instance.AddLuaScript(this);
        }
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
    public void SetObjsToLua(LuaManager luaMan)
    {
        // 获得类型信息
        TypeInfo type = GetType().GetTypeInfo();
        var fields = GetType().GetFields(
                BindingFlags.NonPublic |
                BindingFlags.Public |
                BindingFlags.Instance
            );
        var localSet = typeof(LuaTable).GetMethod("Set");

        // 把自己传到 Lua 中
        foreach (var attr in type.GetCustomAttributes())
        {
            if (attr.GetType() != typeof(LuaObjectAttribute)) continue;

            if (((LuaObjectAttribute)attr).LuaName != null)
            {
                MethodInfo preMethod = localSet.MakeGenericMethod(typeof(string), GetType());
                preMethod.Invoke(
                        _local,
                        new object[]
                        {
                                ((LuaObjectAttribute) attr).LuaName, this
                        });
            }
            else
            {
                MethodInfo preMethod = localSet.MakeGenericMethod(typeof(string), GetType());
                preMethod.Invoke(
                    _local,
                    new object[]
                    {
                            "cs_self", this
                    });
            }

            break;
        }
        // 传递字段到 lua 中
        foreach (var field in fields)
        {
            foreach (var attr in field.GetCustomAttributes())
            {
                if (attr.GetType() != typeof(LuaObjectAttribute)) continue;

                if (((LuaObjectAttribute)attr).LuaName != null)
                {
                    MethodInfo preMethod = localSet.MakeGenericMethod(typeof(string), field.FieldType);
                    preMethod.Invoke(
                            _local,
                            new object[]
                            {
                                ((LuaObjectAttribute) attr).LuaName, field.GetValue(this)
                            });
                }
                else
                {
                    MethodInfo preMethod = localSet.MakeGenericMethod(typeof(string), field.FieldType);
                    preMethod.Invoke(
                        _local,
                        new object[]
                        {
                            field.Name, field.GetValue(this)
                        });

                }
                break;
            }
        }
        // 传递对象列表到 lua 中
        if (gameObjectsToLua != null)
        {
            foreach (var gameobj in gameObjectsToLua)
            {
                if (gameobj.data == null) continue;
                if (gameobj.key != null && gameobj.key != "")
                    _local.Set(gameobj.key, gameobj.data);
                else
                    _local.Set(gameobj.data.name, gameobj.data);
            }
        }
    }
    public void SetBuildingState(bool state)
    {
        _isBuilding = state;
    }
    #endregion
    /// <summary>
    /// 异步载入Lua脚本名称并初始化
    /// </summary>
    private async void LuaBehaviourConstructor()
    {
        _luaScriptBehavioutsLodingCount++;
        _isBuilding = true;

        var location = await Addressables.LoadResourceLocationsAsync(luaAsset).Task;
        if (location.Count == 0)
        {
#if UNITY_EDITOR
            Debug.LogWarning("没有加载任何资源");
#endif
            _luaScriptBehavioutsLodingCount--;
            return;
        }

#if UNITY_EDITOR
        if (location.Count != 1)
        {
            Debug.LogWarning("是否挂载了非脚本物体？");
        }
#endif

        _key = location[0].PrimaryKey;
        while (LuaManager.Instance == null)
        {
            await Task.Delay(LuaManager.DelayTime);
        }
        await LuaManager.Instance.AddLuaScript(this);
        if (_luaScriptBehavioutsLodingCount != 0) _luaScriptBehavioutsLodingCount--;

        // ---------------------- 映射 lua 中的函数到 CS 中 ---------------------------------
        Action luaFunc;
        _local.Get("Start", out luaFunc); if (luaFunc != null) _luaStart = luaFunc;
        _local.Get("Update", out luaFunc); if (luaFunc != null) _luaUpdate = luaFunc;
        _local.Get("FixedUpdate", out luaFunc); if (luaFunc != null) _luaFixedUpdate = luaFunc;
        _local.Get("LateUpdate", out luaFunc); if (luaFunc != null) _luaLateUpdate = luaFunc;
        _local.Get("OnDisable", out luaFunc); if (luaFunc != null) _luaOnDisable = luaFunc;
        _local.Get("OnEnable", out luaFunc); if (luaFunc != null) _luaOnEnable = luaFunc;
        _local.Get("OnGUI", out luaFunc); if (luaFunc != null) _luaOnGUI = luaFunc;
        _local.Get("OnDestroy", out luaFunc); if (luaFunc != null) _luaOnDestroy = luaFunc;
        Action<PointerEventData> luaPointFunc;
        _local.Get("OnDrag", out luaPointFunc); if (luaPointFunc != null) _luaOnDrag = luaPointFunc;
        _local.Get("OnBeginDrag", out luaPointFunc); if (luaPointFunc != null) _luaOnBeginDrag = luaPointFunc;
        _local.Get("OnEndDrag", out luaPointFunc); if (luaPointFunc != null) _luaOnEndDrag = luaPointFunc;
        Action<bool> luafocusFunc;
        _local.Get("OnApplicationFocus", out luafocusFunc); _luaOnApplicationFocus = luafocusFunc;
        _local.Get("OnApplicationPause", out luafocusFunc); _luaOnApplicationPause = luafocusFunc;
        // ---------------------------------------------------------------------------------

        _isBuilding = false;
        _local.Get("Awake", out luaFunc); luaFunc?.Invoke();
        while (_luaScriptBehavioutsLodingCount != 0)
        {
            await Task.Delay(LuaManager.DelayTime);
        }
        _luaStart?.Invoke();
    }
    #endregion

    #region U3D内建函数
    protected void Awake()
    {
        LuaBehaviourConstructor();
    }
    protected void Update()
    {
        _luaUpdate?.Invoke();
    }
    protected void FixedUpdate()
    {
        _luaFixedUpdate?.Invoke();
    }
    protected void LateUpdate()
    {
        _luaLateUpdate?.Invoke();
    }
    protected void OnEnable()
    {
        _luaOnEnable?.Invoke();
    }
    protected void OnDisable()
    {
        _luaOnDisable?.Invoke();
    }
    protected void OnGUI()
    {
        _luaOnGUI?.Invoke();
    }
    protected void OnApplicationFocus(bool focus)
    {
        _luaOnApplicationFocus?.Invoke(focus);
    }
    protected void OnApplicationPause(bool pause)
    {
        _luaOnApplicationPause?.Invoke(pause);
    }
    protected void OnDestroy()
    {
        _luaOnDestroy?.Invoke();
        Destroy();
    }
    public void OnDrag(PointerEventData eventData)
    {
        _luaOnDrag?.Invoke(eventData);
    }
    public void OnBeginDrag(PointerEventData eventData)
    {
        _luaOnBeginDrag?.Invoke(eventData);
    }
    public void OnEndDrag(PointerEventData eventData)
    {
        _luaOnEndDrag?.Invoke(eventData);
    }
    #endregion

    #region 特性
    /// <summary>
    /// 要传送到 Lua 中的对象
    /// </summary>
    [AttributeUsage(
        AttributeTargets.Class |
        AttributeTargets.Field
        , Inherited = true)]
    internal class LuaObjectAttribute : Attribute
    {
        private readonly string _name;

        /// <summary>
        /// 在 Lua 中的名称
        /// </summary>
        public string LuaName
        {
            get { return _name; }
        }

        /// <summary>
        /// 传送到 lua 中的对象
        /// </summary>
        /// <param name="luaName"> 在 lua 中的名字 </param>
        public LuaObjectAttribute(string luaName = null)
        {
            _name = luaName;
        }
    }
    #endregion
}
