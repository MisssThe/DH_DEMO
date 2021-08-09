// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;
// using UnityEngine.UI;
// public class Ship : MonoBehaviour
// {
//     public Button but;
//     public Material material;
//     public GameObject sea;
//     private float height;
//     private float speed;
//     private float direction;
//     private int max_level;
//     private float level_strenth;
//     private float cycle;
//     private Matrix4x4 sea_matri;
//     // Start is called before the first frame update
//     void Start()
//     {
//         if (this.material != null)
//         {
//             height = material.GetFloat("_Height");
//             speed = material.GetFloat("_Speed");
//             direction = material.GetFloat("_WindDir");
//             max_level = material.GetInt("_LevelMax");
//             level_strenth = material.GetFloat("_LevelStrenth");
//             cycle = material.GetFloat("_Cycle");
//             sea_matri = sea.transform.worldToLocalMatrix;
//             Debug.Log(sea_matri);
//         }
//     }

//     // Update is called once per frame
//     void Update()
//     {
//         Vector4 v = sea.transform.InverseTransformPoint(this.transform.position);
//         Vector2 pos = new Vector2(v.x,v.z);
//         // float x = pos.x * 10000;
//         GetHeight(pos,0.03f,0.06f);
//         // Debug.Log(x);
//         // GetHeight(pos);
//     }
//     void GetHeight(Vector2 vertex,float x,float y)
//     {
//         float level = Mathf.Ceil((max_level * vertex / 6).magnitude) * level_strenth;
//         float A = height / level; 
//         float C = speed * Time.time;
//         float c1 = (vertex.x + x) * cycle + C * Mathf.Sin(direction);
//         float c2 = (vertex.x - x) * cycle + C * Mathf.Sin(direction);
//         float c3 = (vertex.y + y) * cycle + C * Mathf.Cos(direction);
//         float c4 = (vertex.y - y) * cycle + C * Mathf.Sin(direction);
//         float h1 = A * Mathf.Sin(c1) * Mathf.Sin(c3);       //right top
//         float h2 = A * Mathf.Sin(c1) * Mathf.Sin(c4);       //right bottom
//         float h3 = A * Mathf.Sin(c2) * Mathf.Sin(c3);       //left  top
//         float h4 = A * Mathf.Sin(c2) * Mathf.Sin(c4);       //left  bottom
//         Vector3 dir = Vector3.Cross(new Vector3(2 * x,h1 - h4,2 * y),new Vector3(2 * x,h2 - h3,2 * y)).normalized;
//         Debug.Log(h1 * 1000 + "," + h2  * 1000 + "," + h3  * 1000 + "," +  h4  * 1000);
//         // Debug.Log(h);
//     }
// }
