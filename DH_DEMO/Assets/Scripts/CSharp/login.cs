using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class login : MonoBehaviour
{
    void Start()
    {
        NetWork.Init();
        NetWork.SendLogIn("Sean","2000619");
        // NetWork.SendToFight("222","Sean");
    }
    private void OnDestroy()
    {
        NetWork.close();
    }
}
