using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tools
{
    public static GameObject MouseRaycast()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if(Physics.Raycast(ray, out hit))
        {
            GameObject go = hit.collider.gameObject;
            return go;
        }
        return null;
    }
}
