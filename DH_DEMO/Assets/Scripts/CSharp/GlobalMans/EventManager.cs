using System;
using System.Collections.Generic;
using UnityEngine;
using XLua;

[RequireComponent(typeof(GameManager))]
[RequireComponent(typeof(LuaManager))]
public class EventManager : MonoBehaviour
{
    [Tooltip("事件系统的require路径")]
    public string eventSystemLuaScriptKey = "";
    private LuaScript eventEnv;

    static private EventManager inst = null;
    /// <summary>
    /// 实例
    /// </summary>
    static public EventManager Instance
    {
        get
        {
            if (inst != null)
                return inst;
            else
                throw new ApplicationException("没有声明事件系统实例！");
        }
    }

    /// <summary>
    /// 发送事件
    /// </summary>
    /// <param name="eventName"> 事件名称 </param>
    public void Send(string eventName)
    {
        if(eventSystemLuaScriptKey == null || eventSystemLuaScriptKey == "")
        {
#if UNITY_EDITOR
            Debug.LogError("事件系统未在 CS 端指明！");
#endif
        }

        LuaManager.Instance.Env.DoString(
            $"EES.Send({eventName})", 
            $"doEvent{DateTime.Now}"
            );
    }

    /// <summary>
    /// 运行 Lua 脚本
    /// </summary>
    /// <param name="LuaCommand"> 要运行的脚本 </param>
    public void CallLua(string LuaCommand)
    {
        LuaManager.Instance.Env.DoString(
            LuaCommand,
            $"doEvent{DateTime.Now}"
            );
    }

    void AddToGlobal()
    {
        LuaManager.Instance.Env.Global.Set("EES", eventEnv.Local);
    }

    void Awake()
    {
        if (inst == null)
        {
            inst = this;
            DontDestroyOnLoad(gameObject);
            eventEnv = new LuaScript(eventSystemLuaScriptKey, null, AddToGlobal);
        }
        else
            Destroy(gameObject);
    }
}
