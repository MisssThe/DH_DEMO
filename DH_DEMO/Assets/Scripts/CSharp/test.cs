using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class test : MonoBehaviour
{



    void Awake()
    {
        NetWork.Init();
    }
    void Start()
    {
        Debug.Log("发送消息");
        NetWork.SendTalk("111", "111", "你好呀");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void Destroy()
    {
    }
}
