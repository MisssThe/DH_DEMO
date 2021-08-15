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
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void Destroy()
    {
    }
}
