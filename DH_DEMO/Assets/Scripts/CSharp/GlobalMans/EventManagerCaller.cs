using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventManagerCaller : MonoBehaviour
{
    /// <summary>
    /// <para> 发送事件 </para>
    /// 事件内容的格式形如:
    /// "1 \"eventType\" \"instName\" param1 param2 ..." 或 "0 \"eventType\" ...", 
    /// 这里的第一个数字代表是否有instName, 后面则是要发送的具体事件内容, 各参数中间用空格隔开, 
    /// </summary>
    /// <param name="eventContent"> 事件内容 </param>
    public void Send(string eventContent)
    {
        EventManager.Instance.Send(eventContent);
    }
}
