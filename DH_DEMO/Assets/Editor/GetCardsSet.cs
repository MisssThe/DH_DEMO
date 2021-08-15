using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Text;
using System.IO;
public class GetCardsSet : MonoBehaviour
{
    // 读取excel文件生成卡牌集
    [MenuItem("Tools/GetCardsFromExcel")]
    public static void GetCardsFromExcel()
    {
        // // io读取excel文件
        FileStream fs = new FileStream(@"C:\Users\dh_xly1\Desktop\卡牌集.csv", FileMode.Open, FileAccess.Read, FileShare.None);
        StreamReader sr = new StreamReader(fs, System.Text.Encoding.GetEncoding(936));
        
        
        string str = "";
        while (str != null)
        {    
            str = sr.ReadLine();
            string[] xu = new string[2];
            Debug.Log(str);
        }   sr.Close();
    }
}
