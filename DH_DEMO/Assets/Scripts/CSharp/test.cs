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
        NetWork.SendLogIn("111", "333");
        NetWork.SendTalk("111","222","648848");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void Destroy()
    {
    }
}
