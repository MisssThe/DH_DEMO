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
        //StartCoroutine(Time());
        NetWork.SendTalk("111", "111", "你好呀");
    }

    IEnumerator Time()
    {
        while (!NetWork.client.Connected)
        {
            yield return new WaitForSeconds(1);
        }
        NetWork.SendTalk("111", "111", "你好呀");
    }

}
