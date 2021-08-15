using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class login : MonoBehaviour
{
    void Start()
    {
        NetWork.Init();
        NetWork.SendLogIn("222","222");
        NetWork.SendToFight("222","111");
    }
}
