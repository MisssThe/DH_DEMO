using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 游戏管理器
/// </summary>
public class GameManager : MonoBehaviour
{
    static private GameManager inst = null;
    /// <summary>
    /// 实例
    /// </summary>
    static public GameManager Instance { 
        get 
        {
            if (inst != null)
                return inst;
            else
                throw new ApplicationException("没有声明游戏管理器实例！");
        } 
    }

    void Awake()
    {
        if(inst == null)
        {
            inst = this;
            DontDestroyOnLoad(gameObject);
        }
        else
            Destroy(gameObject);
    }
}
