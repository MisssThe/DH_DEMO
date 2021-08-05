using System;
using System.Collections.Generic;
using XLua;

public static class LuaConfigures
{
    [CSharpCallLua]
    public static List<Type> CSharpCallLua = new List<Type>() {
            typeof(Action),
            typeof(Func<double, double, double>),
            typeof(Action<string>),
            typeof(Action<double>),
            typeof(Action<bool>),
            typeof(UnityEngine.Events.UnityAction),
        };
}
