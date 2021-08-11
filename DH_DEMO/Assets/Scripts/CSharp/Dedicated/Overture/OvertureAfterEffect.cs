using System.Collections;
using System.Collections.Generic;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine;

public class OvertureAfterEffect : MonoBehaviour
{
    public List<AssetReference> materials;
    public AssetReference blendMaterial;
    public AssetReference blendRendertexture;
    [Range(0, 1)] public float blendAlpha;

    private List<Material> mats = new List<Material>();
    private RenderTexture blendRt;
    private Material blendMat;
    private RenderTexture temp1;
    private RenderTexture temp2;

    void Awake()
    {
        if (blendRendertexture != null)
        {
            var blendrtOpt = blendRendertexture.LoadAssetAsync<RenderTexture>();
            blendrtOpt.WaitForCompletion();
            blendRt = blendrtOpt.Result;
        }
        if(materials != null && materials.Count > 0)
        {
            foreach (var matRef in materials)
            {
                var matOpt = matRef.LoadAssetAsync<Material>();
                matOpt.WaitForCompletion();
                mats.Add(matOpt.Result);
            }
        }
        if (blendMaterial != null)
        {
            var blmOpt = blendMaterial.LoadAssetAsync<Material>();
            blmOpt.WaitForCompletion();
            blendMat = blmOpt.Result;
        }

        temp1 = new RenderTexture(Screen.width, Screen.height, 24);
        temp2 = new RenderTexture(Screen.width, Screen.height, 24);
    }
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if(blendMat != null && blendRt != null)
        {
            blendMat.SetTexture("_BlendTex", blendRt);
            blendMat.SetFloat("_Alpha", blendAlpha);
            Graphics.Blit(src, temp1, blendMat);
        }

        if (mats.Count > 0)
        {
            if (blendMat != null && blendRt != null)
            {
                Graphics.Blit(temp1, temp2, mats[0]);
                var tempSwitch = temp1;
                temp1 = temp2;
                temp2 = tempSwitch;
            }
            else Graphics.Blit(src, temp1, mats[0]);
            if (mats.Count > 1)
            {
                foreach(var mat in mats)
                {
                    Graphics.Blit(temp1, temp2, mat);
                    var tempSwitch = temp1;
                    temp1 = temp2;
                    temp2 = tempSwitch;
                }
            }

            Graphics.Blit(temp1, dest);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
