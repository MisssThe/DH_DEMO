using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class AfterScreen : MonoBehaviour
{
    public static Material base_material;
    public static bool use_base = true;
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
        if (!use_base)
        {
            Graphics.Blit(src,dest);            
        }
        else
        {
            if (base_material != null)
            {
                Graphics.Blit(src,dest,base_material);
            }
        }
    }
}
