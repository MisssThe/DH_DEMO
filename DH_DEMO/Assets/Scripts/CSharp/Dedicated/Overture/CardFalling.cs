using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CardFalling : MonoBehaviour
{
    [HideInInspector] public RenderTexture tex;

    private void Awake()
    {
        tex = new RenderTexture(1920, 1080, 8);
        GetComponent<Camera>().targetTexture = tex;
    }
}
