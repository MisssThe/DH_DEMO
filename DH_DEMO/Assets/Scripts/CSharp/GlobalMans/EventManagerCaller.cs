using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventManagerCaller : MonoBehaviour
{
    void Send(string eventName)
    {
        EventManager.Instance.Send(eventName);
    }
}
