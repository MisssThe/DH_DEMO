using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OvertureManager : MonoBehaviour
{
    [SerializeField] private LuaScriptBehaviour overtureManager;
    bool atTheBeginning = true;
    [SerializeField] private Animator cameraInLoading;
    
    IEnumerator WaitForLoading()
    {
        if (atTheBeginning)
        {
            yield return new WaitForSeconds(4);
            atTheBeginning = false;
        }
        if (overtureManager.IsBuilding == false)
        {
            EventManager.Instance.Send("1 'CardsFalling' 'OvertureManager'");
            cameraInLoading.SetTrigger("CardsFall");
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
