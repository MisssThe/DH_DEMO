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
        int length = 0;
        foreach (var item in fi)
        {
            if (item.Extension.Equals(".meta"))
            {
                if(item.FullName.Substring(item.FullName.Length - 9,4).Equals(".lua"))
                {
                    // Debug.Log("meta:" + item.FullName);
                    // f0566627eefce6d4fbf9387ebc9c5710
                    item.MoveTo(item.FullName.Substring(0,item.FullName.Length - 8) + "bytes.meta");
                }
            }
            if (item.Extension.Equals(".lua"))
            {
                // item.MoveTo
                item.MoveTo(item.FullName.Substring(0,item.FullName.Length - 3) + "bytes");
                // Debug.Log("lua" + item.FullName);
            }
            // else
            // {
            //     new_str = item.FullName.Substring(0,length - 5);
            //     Debug.Log(new_str);
            //     //  + "bytes.meta");
            // }
        }

        StreamWriter sw = new StreamWriter(@"Assets\AddressableAssetsData\AssetGroups\Lua Assets.asset",false);
        foreach (var item in list)
        {
            sw.WriteLine(item);
        }
        sw.Close();
    }
}
