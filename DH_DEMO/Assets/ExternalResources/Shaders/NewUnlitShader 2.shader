// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

/*
    使用几何着色器扩散物体
*/
Shader "Custom/CardSeaEffect1"
{
    Properties
    {
        //卡牌偏移
        _MainTex ("Main Texture",2D) = ""{}
        _CardNum_X ("Card Number X",Float) = 0
        _CardNum_Z ("Card Number Z",Float) = 0
        _Offset_Y ("Offset Y",Float) = 0
        _Offset_Z ("Offset Z",Float) = 0
        _Offset_X ("Offset X",Float) = 0
        //波浪控制
        _Height ("Height",Float) = 0
        _Cycle ("Cycle",Float) = 0
        _Speed ("Speed",Float) = 0
        _TessStrenth ("Tessellation Strenth",Float) = 0
        _TessMax ("Tessellation Max",Float) = 0
    }
    SubShader
    {
        pass
        {
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #pragma geometry main_g
            #pragma hull main_h
            #pragma domain main_d
            #include "Lighting.cginc"
            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 texcoord:TEXCOORD0;
            };
            struct v2t
            {
                float4 vertex:INTERNALTESSPOS;
                float3 normal:NORMAL;
                float4 texcoord:TEXCOORD0;
            };
            struct t2g
            {
                float4 vertex:POSITION;
                float3 normal:TEXCOORD1;
                float4 texcoord:TEXCOORD0;
            };
            struct g2f
            {
                float4 pos:SV_POSITION;
                float3 world_normal:TEXCOORD1;
                float3 world_pos:TEXCOORD2;
                float2 uv:TEXCOORD0;
                float num:TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _CardNum_X;
            float _CardNum_Z;
            half _Offset_Y;
            half _Offset_Z;
            half _Offset_X;
            half _Height;
            half _Cycle;
            half _Speed;
            half _TessMax;
            half _TessStrenth;

            t2g vert(a2v i)
            {
                t2g o;
                o.vertex = i.vertex + float4(0,_Height * sin(i.vertex.z + i.vertex.x * _Cycle + _Speed * _Time.y),0,0);
                // o.vertex.z += _Speed * _Time.y;
                o.texcoord = i.texcoord;
                o.normal = i.normal;
                return o;
            }
            v2t main_v(a2v v) {
                v2t o;
                o.vertex = v.vertex;
                o.normal = v.normal;
                o.texcoord = v.texcoord;
                return o;
            }
            //控制曲面细分
            UnityTessellationFactors hsconst (InputPatch<v2t,3> i) 
            {
                UnityTessellationFactors o;
                //根据摄像机距离计算细分因子
                // float4 factor = _WorldSpaceCameraPos - UnityObjectToClipPos();
                float factor = 1;
                fixed3 dis = (mul(unity_ObjectToWorld,i[0].vertex) + mul(unity_ObjectToWorld,i[1].vertex) + mul(unity_ObjectToWorld,i[1].vertex)) * 0.33333;
                dis = _WorldSpaceCameraPos - dis;
                factor = _TessMax - (abs(dis.x) + abs(dis.y) + abs(dis.z)) * _TessStrenth;
                o.edge[0] = factor; 
                o.edge[1] = factor; 
                o.edge[2] = factor; 
                o.inside = factor;
                return o;
            }
            [UNITY_domain("tri")]
            [UNITY_partitioning("fractional_odd")]
            [UNITY_outputtopology("triangle_cw")]
            [UNITY_patchconstantfunc("hsconst")]
            [UNITY_outputcontrolpoints(3)]
            v2t main_h(InputPatch<v2t,3> v, uint id : SV_OutputControlPointID) 
            {
                return v[id];
            }
            [UNITY_domain("tri")]
            t2g main_d(UnityTessellationFactors tessFactors,const OutputPatch<v2t,3> i,float3 bary:SV_DomainLocation) 
            {
                a2v v;
                v.vertex = i[0].vertex*bary.x + i[1].vertex*bary.y + i[2].vertex*bary.z;
                v.normal = i[0].normal*bary.x + i[1].normal*bary.y + i[2].normal*bary.z;
                v.texcoord = i[0].texcoord*bary.x + i[1].texcoord*bary.y + i[2].texcoord*bary.z;
                t2g o = vert(v);
                return o;
            }
            //几何阶段
            [maxvertexcount(10)]
            void main_g(triangle t2g p[3], inout TriangleStream<g2f> stream) 
            {
				g2f o[3];
                float2 temp = (p[0].vertex.xz + p[1].vertex.xz + p[2].vertex.xz) * 0.333;
                int2 num = ceil(temp.xy + 6) - 2;
                half n = 12 / _CardNum_Z;
                p[0].vertex.y += (p[0].vertex.z - num.y * n) * _Offset_Y;
                p[1].vertex.y += (p[1].vertex.z - num.y * n) * _Offset_Y;
                p[2].vertex.y += (p[2].vertex.z - num.y * n) * _Offset_Y;
                p[0].vertex.x += (num.x + 0.5) * _Offset_X;
                p[0].vertex.z -= num.y * _Offset_Z;
                p[1].vertex.z -= num.y * _Offset_Z;
                p[1].vertex.x += (num.x + 0.5) * _Offset_X;
                p[2].vertex.z -= num.y * _Offset_Z;
                p[2].vertex.x += (num.x + 0.5) * _Offset_X;
                if (fmod(num.x,2) > 0.5)
                {
                    p[0].vertex.z -= _Offset_Z;
                    p[1].vertex.z -= _Offset_Z;
                    p[2].vertex.z -= _Offset_Z;
                }
                o[0].pos = UnityObjectToClipPos(p[0].vertex);
                o[0].uv = TRANSFORM_TEX(p[0].texcoord,_MainTex);
                o[0].world_pos = mul(unity_ObjectToWorld,p[0].vertex);
                o[1].pos = UnityObjectToClipPos(p[1].vertex);
                o[1].uv = TRANSFORM_TEX(p[1].texcoord,_MainTex);
                o[1].world_pos = mul(unity_ObjectToWorld,p[1].vertex);
                o[2].pos = UnityObjectToClipPos(p[2].vertex);               
                o[2].uv = TRANSFORM_TEX(p[2].texcoord,_MainTex);
                o[2].world_pos = mul(unity_ObjectToWorld,p[2].vertex);
                o[0].num = num.x;
                o[1].num = num.x;
                o[2].num = num.x;
                float3 world_normal = normalize(cross(o[0].world_pos - o[1].world_pos,o[1].world_pos - o[2].world_pos));
                o[0].world_normal = world_normal;
                o[1].world_normal = world_normal;
                o[2].world_normal = world_normal;
                stream.Append(o[0]);
                stream.Append(o[1]);
                stream.Append(o[2]);
            }
            fixed4 main_f(g2f i):SV_TARGET
            {
                fixed3 normal_dir = normalize(i.world_normal);
                fixed3 light_dir = UnityWorldSpaceLightDir(i.world_pos);
                fixed3 albedo = tex2D(_MainTex,i.uv);
                fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(normal_dir,light_dir));
                // return fixed4(i.num,0,0,1);
                return fixed4(diffuse,1);
                // return fixed4(_Time.y * _Speed,0,0,1);
            }
            ENDCG
        }
    }
}
