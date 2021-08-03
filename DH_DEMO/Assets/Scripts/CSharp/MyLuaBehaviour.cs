using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.IO;
using XLua;


[Hotfix]
public class MyLuaBehaviour : MonoBehaviour
{
    LuaEnv lua_env;
    LuaTable lua_table;

    public LuaAsset lua_text;//记得改为private

    static float last_gc_time = 0;

    const float gc_interval = 1;
    Action Event;
    Action awake;
    Action start;
    Action fixupdate;
    Action update;
    Action lateupdate;
    Action ondestroy;

    private byte[] MyLoader(ref string fileName)
    {
        byte[] by_array_return = null;//返回数据
                                    //定义lua路径
        string lua_path = Application.dataPath + "/Resources/Scripts/Lua/" + fileName + ".lua.txt";
        //读取lua路径中指定lua文件内容
        string str_lua_content = File.ReadAllText(lua_path);
        //数据类型转换
        by_array_return = System.Text.Encoding.UTF8.GetBytes(str_lua_content);
        return by_array_return;
    }

    private void Init()
    {
        lua_env =  LuaEnvironment.instance.GetLuaEnv();
        lua_env.AddLoader(MyLoader);
        lua_table = lua_env.NewTable();
        LuaTable meta = lua_env.NewTable();
        meta.Set("__index",lua_env.Global);
        lua_table.SetMetaTable(meta);
        meta.Dispose();
        //初始化lua_path

        //初始化lua_text

        lua_table.Set("self",this);

        lua_env.DoString(lua_text.data,this.gameObject.name,lua_table);

        lua_table.Get("Event",out Event);
        lua_table.Get("Awake",out awake);
        lua_table.Get("Start",out start);
        lua_table.Get("FixUpdate",out fixupdate);
        lua_table.Get("Update",out update);
        lua_table.Get("LateUpdate",out lateupdate);
        lua_table.Get("OnDestroy",out ondestroy);

    }
    void Awake()
    {
        Init();
        if(awake != null)
        {
            awake();
        }else
        {
            Debug.Log("awake is null");
        }
    }

    void Start()
    {
        if(start != null)
        {
            start();
        }else
        {
            Debug.Log("start is null");
        }
    }

    void FixUpdate()
    {
        if(fixupdate != null)
        {
            fixupdate();
        }else
        {
            Debug.Log("fixupdate is null");
        }
    }

    void Update()
    {
        if(update != null)
        {
            update();
        }else 
        {
            Debug.Log("update is null");
        }

        if(Time.time - MyLuaBehaviour.last_gc_time > gc_interval)
        {
            lua_env.Tick();
            MyLuaBehaviour.last_gc_time = Time.time;
        }
    }

    void LateUpdate()
    {
        if(lateupdate != null)
        {
            lateupdate();
        }else
        {
            Debug.Log("lateupdate is null");
        }
    }

    void OnDestroy()
    {
        if(ondestroy != null)
        {
            ondestroy();
        }else
        {
            Debug.Log("ondestroy is null");
        }
    }
}
