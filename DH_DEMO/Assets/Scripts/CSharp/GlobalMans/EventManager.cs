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
    /// <para> 发送事件 </para>
    /// 事件内容的格式形如:
    /// "1 'eventType' 'instName' param1 param2 ..." 或 "0 'eventType' ...", 
    /// 这里的第一个数字代表是否有instName, 后面则是要发送的具体事件内容, 各参数中间用空格隔开, 
    /// </summary>
    /// <param name="eventContent"> 事件内容 </param>
    public void Send(string eventContent)
    {
        string[] singleEventContent = eventContent.Split(' ');
        if (singleEventContent[0] != "0" && singleEventContent[0] != "1")
        {
#if UNITY_EDITOR
            Debug.LogError("妄图发送格式不正确的事件");
#endif
            return;
        }
        else
        {
            if (eventSystemLuaScriptKey == null || eventSystemLuaScriptKey == "")
            {
#if UNITY_EDITOR
                Debug.LogError("事件系统未在 CS 端指明！");
#endif
                return;
            }

            string finalEventContent = "";
            int startPtr = 0;
            if (singleEventContent[0] == "0")
            {
                finalEventContent = singleEventContent[1] + ", [[]]";
                startPtr = 2;
            }
            else
            {
                if (singleEventContent.Length < 3)
                {
#if UNITY_EDITOR
                    Debug.LogError("妄图发送格式不正确的事件");
#endif
                    return;
                }
                finalEventContent = singleEventContent[1] + ", " + singleEventContent[2];
                startPtr = 3;
            }

            for (int idx = startPtr; idx < singleEventContent.Length; idx++)
            {
                finalEventContent += ", " + singleEventContent[idx];
            }

            if (!LuaManager.Instance.IsLoading)
            {
                LuaManager.Instance.Env.DoString(
                    $"ExEES.Send({finalEventContent})",
                    $"doEvent {DateTime.Now}", LuaManager.Instance.Env.Global
                );
            }
            else
#if UNITY_EDITOR
                Debug.LogError("尝试在事件系统初始化前发送事件");
#endif
        }
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

    void Awake()
    {
        if (inst == null)
        {
            inst = this;
            DontDestroyOnLoad(gameObject);
        }
        else
            Destroy(gameObject);
    }
}
