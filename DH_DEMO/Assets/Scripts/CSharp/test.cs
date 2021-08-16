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
        NetWork.SendLogIn("Sean", "2000619");
        NetWork.SendTalk("Sean","222","666");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void Destroy()
    {
    }
}
