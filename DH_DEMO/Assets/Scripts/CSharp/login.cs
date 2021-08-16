using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class login : MonoBehaviour
{
    void Start()
    {
        NetWork.Init();
        NetWork.SendLogIn("111","333");
    }
}
