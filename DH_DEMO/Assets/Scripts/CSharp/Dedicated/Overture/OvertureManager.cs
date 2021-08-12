using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OvertureManager : MonoBehaviour
{
    [SerializeField] private LuaScriptBehaviour overtureManager;
    bool atTheBeginning = true;
    
    IEnumerator WaitForLoading()
    {
        if (atTheBeginning)
        {
            yield return new WaitForSeconds(3);
            atTheBeginning = false;
        }
        if (overtureManager.IsBuilding == false)
        {
            EventManager.Instance.Send("0 [[CardsFalling]]");
            yield break;
        }
        yield return new WaitForSeconds(1);
    }

    void Awake()
    {
        StartCoroutine(WaitForLoading());
    }

    void Update()
    {
        
    }
}
