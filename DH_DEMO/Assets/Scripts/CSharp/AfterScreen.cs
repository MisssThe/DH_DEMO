using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class AfterScreen : MonoBehaviour
{
    public List<Material> mat;
    // Start is called before the first frame update
    void Start()
    {
        Camera camera = this.GetComponent<Camera>();
        if (camera != null)
        {
            camera.depthTextureMode = DepthTextureMode.DepthNormals;
        }
    }
    private void OnRenderImage(RenderTexture src, RenderTexture dest) 
    {
        if (mat != null && mat.Count > 0)
        {
            // dest = src;
            // foreach (var item in mat)
            // {
            //     Graphics.Blit(src,dest,item);
            //     Debug.Log("blit");
            // }
            RenderTexture temp = new RenderTexture(Screen.width,Screen.height,24);
            Graphics.Blit(src,temp,mat[0],0);
            Graphics.Blit(temp,dest,mat[0],1);
        }
        else
        {
            Graphics.Blit(src,dest);
        }
    }
}
