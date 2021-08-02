using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
public class LuaEnvironment 
{
    public static LuaEnvironment instance = new LuaEnvironment();
    private LuaEnvironment(){}


    //添加所需要的环境和访问方法

    
    private LuaEnv lua_env = new LuaEnv ();
    public LuaEnv GetLuaEnv()
    {
        return lua_env;
    }



    



    
}
