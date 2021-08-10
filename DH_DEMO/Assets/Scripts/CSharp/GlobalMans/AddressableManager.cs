using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;

public static class AddressableManager
{
    public static Material LoadMaterialSync(string PrimaryKey)
    {
        var matOpt = Addressables.LoadAssetAsync<Material>(PrimaryKey);
        matOpt.WaitForCompletion();
        return matOpt.Result;
    }
}
