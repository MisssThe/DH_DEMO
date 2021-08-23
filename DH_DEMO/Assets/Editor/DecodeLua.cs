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
        // 保存lua asset文件内容
        FileStream fs = new FileStream(@"Assets\AddressableAssetsData\AssetGroups\Lua Assets.asset",FileMode.Open, FileAccess.Read, FileShare.None);
        StreamReader sr = new StreamReader(fs);
        List<string> list = new List<string>();
        string str = sr.ReadLine();
        while (str != null)
        {
            list.Add(str);
            str = sr.ReadLine();
        }
        sr.Close();


        string new_str = null;
        foreach (var item in fi)
        {
            int length = item.FullName.Length - 4;
            new_str = item.FullName.Substring(length,4);
            if (!new_str.Equals("meta"))
            {
                new_str = item.FullName.Substring(0,length + 1);
                item.MoveTo(new_str + "bytes");
            }
        }

        StreamWriter sw = new StreamWriter(@"Assets\AddressableAssetsData\AssetGroups\Lua Assets.asset",false);
        foreach (var item in list)
        {
            sw.WriteLine(item);
        }
        sw.Close();
    }
}
