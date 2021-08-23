using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
public class DecodeLua : MonoBehaviour
{
    [MenuItem("Tools/Decode Lua")]
    public static void Decode()
    {
        DirectoryInfo di = new DirectoryInfo("Assets/Scripts/Lua");
        FileInfo[] fi = di.GetFiles("*", SearchOption.AllDirectories);
        string new_str = null;
        foreach (var item in fi)
        {
            int length = item.FullName.Length - 4;
            new_str = item.FullName.Substring(length,4);
            if (!new_str.Equals("meta"))
            {
                item.MoveTo(new_str + "bytes");
                Debug.Log(item.FullName);
            }
        }
    }
}
