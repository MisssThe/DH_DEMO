using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class AfterScreen : MonoBehaviour
{
    public List<Material> mat;
    private RenderTexture temp1;
    private RenderTexture temp2;
    // Start is called before the first frame update
    void Start()
    {
        Camera camera = this.GetComponent<Camera>();
        if (camera != null)
        {
            camera.depthTextureMode = DepthTextureMode.DepthNormals;
        }
        temp1 = new RenderTexture(Screen.width,Screen.height,24);
        temp2 = new RenderTexture(Screen.width,Screen.height,24);
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
            Graphics.Blit(src,dest,mat[0]);
        }
        else
        {
            Graphics.Blit(src,dest);
        }
    }
}
