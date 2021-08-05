using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO; 

/*
    创建场景构建所需工具
*/
public class ShaderTools
{
    //所需shader存放于Shader/Editor目录下
    private static Dictionary<string,Shader> shader_list;
    //更新shader列表
    [MenuItem("Shader/Update Shader List")]
    public static void UpdateShaderList()
    {
        if (shader_list == null)
        {
            shader_list = new Dictionary<string,Shader>();
        }
        shader_list.Clear();
        //扫描路径文件
        string path = "Assets/ExternalResources/Shaders/Editor";
        DirectoryInfo di = new DirectoryInfo(path);
        if (di.Exists)
        {
            FileInfo[] files = di.GetFiles();
            foreach (var item in files)
            {
                if (!item.Extension.Equals(".meta"))
                {
                    string shader_name = item.Name.Replace(".shader",string.Empty);
                    shader_list.Add(shader_name,Shader.Find("Custom/" + shader_name));
                }
            }
        }
    }
    //用对应材质处理贴图
    private static void ProcessTexture(RenderTexture rt,Material mt) 
    {
        if (rt != null && mt != null)
        {
            Graphics.Blit(rt,rt,mt);
        }
    }

    //将rt图输出为一张纹理
    private static string png_name;
    private static string contents;
    private static void KeepRenderTexture(RenderTexture rt)
    {
        if (rt != null)
        {
            RenderTexture prev = RenderTexture.active;
            RenderTexture.active = rt;
            Texture2D png = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false);
            png.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            byte[] bytes = png.EncodeToPNG();
            if (!Directory.Exists(contents))
            {
                Directory.CreateDirectory(contents);
            }
            FileStream file = File.Open(contents + "/" + png_name + ".png", FileMode.Create);
            BinaryWriter writer = new BinaryWriter(file);
            writer.Write(bytes);
            file.Close();
            Texture2D.DestroyImmediate(png);
            png = null;
            RenderTexture.active = prev;
        }
    }

    //添加rt图
    private static void AddRenderTexture(RenderTexture m_rt)
    {
        GameObject[] obj = GameObject.FindGameObjectsWithTag("MainCamera");
        foreach (var item in obj)
        {
            item.GetComponent<Camera>().targetTexture = m_rt;
        }
    }

    //移动相机
    private static void MoveCamera(Vector3 pos,Vector3 rot)
    {
        GameObject[] objs = GameObject.FindGameObjectsWithTag("MainCamera");
        foreach (var item in objs)
        {
            item.transform.position = pos;
            item.transform.rotation = Quaternion.Euler(rot);
        }
    }
    private static void MoveCameraToTop()
    {
        MoveCamera(new Vector3(500,800,500),new Vector3(90,0,0));
    }

    //根据指定材质获取顶部RT图
    private struct TempTransform
    {
        public TempTransform(Vector3 pos, Quaternion rot)
        {
            this.position = pos;
            this.rotation = rot;
        }
        public Vector3 position;
        public Quaternion rotation;
    }
    private static List<TempTransform> temp_transform_list;
    private static RenderTexture RenderTextureOnTop(string shader_name)
    {
        UpdateShaderList();
        Shader shader = shader_list[shader_name];
        if (shader == null)
        {
            Debug.Log("shader not exist!");
            return null;
        }
        Material mat = new Material(shader);
        RenderTexture rt = new RenderTexture(UnityEngine.Screen.width,UnityEngine.Screen.height,24);
        AddRenderTexture(rt);
        // 移动相机位置
        if (temp_transform_list == null)
        {
            temp_transform_list = new List<TempTransform>();
        }
        GameObject[] cameras = GameObject.FindGameObjectsWithTag("MainCamera");
        foreach (var item in cameras)
        {
            temp_transform_list.Add(new  TempTransform(item.transform.position,item.transform.rotation));
        }
        MoveCameraToTop();
        ProcessTexture(rt,mat);
        AddRenderTexture(null);
        RestoreCameraTransfrom();
        return rt;
    }
    private static void RestoreCameraTransfrom()
    {
        //返回摄像机位置
        GameObject[] camera = GameObject.FindGameObjectsWithTag("MainCamera");
        int offset = 0;
        foreach (var item in camera)
        {
            item.transform.position = temp_transform_list[offset].position;
            item.transform.rotation = temp_transform_list[offset].rotation;
        }
        temp_transform_list.Clear();
    }


    //获取当前场景海平面深度图
    [MenuItem("Shader/Create Height Texture")]
    public static void CreateHeightTex()
    {
        RenderTexture rt = RenderTextureOnTop("GetDepthTexture");
        png_name = "depth";
        contents = @"Assets/ExternalResources/Picture/RenderTexture";
        KeepRenderTexture(rt);
    }

    //获取海底深度图
    private static GameObject[] seas;
    [MenuItem("Shader/Create Height Texture Under Sea")]
    public static void CreateHeightTexUnderSea()
    {
        //将海面去除
        seas = GameObject.FindGameObjectsWithTag("Sea");
        foreach (var item in seas)
        {
            item.SetActive(false);
        }
        RenderTexture rt = RenderTextureOnTop("GetDepthTexture");
        png_name = "depth_under_sea";
        contents = @"Assets/ExternalResources/Picture/RenderTexture";
        KeepRenderTexture(rt);
        //恢复海面
        foreach (var item in seas)
        {
            item.SetActive(true);
        }
        seas = null;
    }
}
