using XLua;

/// <summary>
/// 默认的 Lua 脚本加载器
/// </summary>
[Hotfix]
[LuaObject]
[LuaCallCSharp]
public class DefaultLuaBehaviour : LuaScriptBehaviour
{
    new void Awake()
    {
        base.Awake();
    }
    new void Update()
    {
        base.Update();
    }
    new void FixedUpdate()
    {
        base.FixedUpdate();
    }
    new void LateUpdate()
    {
        base.LateUpdate();
    }
    new void OnEnable()
    {
        base.OnEnable();
    }
    new void OnDisable()
    {
        base.OnDisable();
    }
    new void OnGUI()
    {
        base.OnGUI();
    }
    new void OnApplicationFocus(bool focus)
    {
        base.OnApplicationFocus(focus);
    }
    new void OnApplicationPause(bool pause)
    {
        base.OnApplicationPause(pause);
    }
    new void OnDestroy()
    {
        base.OnDestroy();
    }
}
