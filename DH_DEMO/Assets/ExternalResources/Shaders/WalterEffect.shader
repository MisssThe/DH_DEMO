// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

/*
    模拟海面效果
    使用顶点偏移+法线重构模拟海浪效果,使用细分着色提升效果
    海边海浪比较低速度慢，中间区域比较高(将海域分级),
    海浪高处会有气泡
    需要将船体设为透明
*/
Shader "Custom/WalterEffect"
{
    Properties
    {
        //控制海浪属性
        _Cycle ("Cycle",Float) = 0
        _Height ("Height",Float) = 0
        _Speed ("Speed",Float) = 0
        _NoiseTex ("Noise Texture",2D) = ""{}
        _NoiseStrenth ("Noise Strenth",float) = 0
        _TessStrenth ("Tessellation Strenth",Float) = 0
        _TessMax ("Tessellation Max",Float) = 0
        _WindDir ("Wind Direction",Range(0,360)) = 0
        _LevelMax ("Level Max",Float) = 0
        _LevelStrenth ("Level Strenth",Float) = 0
        //控制海面属性
        _Color ("Color",Color) = (1,1,1,1)
        _HalfDiffuse ("Half Diffuse",Range(0,1)) = 0
        _HeigthTex ("Heigth Texture",2D) = ""{}
        _MiniOffset ("_MiniOffset",Range(0,1)) = 0
        _FresnelStrenth ("_Fresnel Strenth",Float) = 0
        _RefractAmount ("Refract Amount",Float) = 0
        //描边控制
        _OutlineStrenth ("Outline Strenth",Float) = 0
        _OutlineColor ("Outline Color",Color) = (1,1,1,1)
    }
    SubShader
    {
        CGINCLUDE
        #include "Tools.cginc"
        //structure 
        struct a2v
        {
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float4 texcoord:TEXCOORD0;
        };
        struct t2v 
        {
            float4 vertex : INTERNALTESSPOS;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
        };
        struct v2f
        {
            float4 pos:SV_POSITION;
            float3 world_normal:TEXCOORD1;
            float3 world_pos:TEXCOORD2;
            float4 grab_uv:TEXCOORD3;
            float2 uv:TEXCOORD4;
            half height:TEXCOORD5;
        };
        struct v2f_back
        {
            float4 pos:SV_POSITION;
        };
        //element
        half _Height;
        half _Cycle;
        half _Speed;
        half _TessStrenth;
        half _TessMax;
        half _WindDir;
        sampler2D _NoiseTex;
        float4 _NoiseTex_ST;
        float _NoiseStrenth;
        fixed4 _Color;
        sampler2D _HeigthTex;
        float _MiniOffset;
        half _FresnelStrenth;
        half _LevelMax;
        fixed _HalfDiffuse;
        float _LevelStrenth;
        half _RefractAmount;
        half _OutlineStrenth;
        
        //function
        v2f vert(a2v i)
        {
            v2f o;
            float level = ceil(length(_LevelMax * i.vertex.xz / 6)) * _LevelStrenth;
            float A = (_Height) / level; 
            float C = _Speed * TIME;
            float c1 = i.vertex.x * _Cycle + C * sin(_WindDir);
            float c2 = i.vertex.z * _Cycle + C * cos(_WindDir);
            fixed height = A * sin(c1) * sin(c2);
            A *= _Cycle;
            i.normal = float3(A * cos(c1) * sin(c2),1,A * sin(c1) * cos(c2));
            i.vertex.y += height;

            o.pos = UnityObjectToClipPos(i.vertex);
            o.world_normal = UnityObjectToWorldNormal(i.normal);
            o.world_pos = mul(unity_ObjectToWorld,i.vertex);
            o.grab_uv  = ComputeGrabScreenPos(o.pos);
            o.height = height;
            return o;
        }
        v2f_back vert_back(a2v i)
        {
            v2f_back o;
            float level = ceil(length(_LevelMax * i.vertex.xz / 6)) * _LevelStrenth;
            float A = (_Height) / level; 
            float C = _Speed * TIME;
            float c1 = i.vertex.x * _Cycle + C * sin(_WindDir);
            float c2 = i.vertex.z * _Cycle + C * cos(_WindDir);
            fixed height = A * sin(c1) * sin(c2);
            A *= _Cycle;
            i.normal = float3(A * cos(c1) * sin(c2),1,A * sin(c1) * cos(c2));
            i.vertex.y += height;

            float3 view_normal = mul(UNITY_MATRIX_IT_MV,i.normal);
            float3 view_pos = UnityObjectToViewPos(i.vertex);
            view_normal.z = -0.5;
            view_pos += view_normal * _OutlineStrenth;
            o.pos = UnityViewToClipPos(view_pos);
            return o;
        }
        t2v main_v(a2v v) {
            t2v o;
            o.vertex = v.vertex;
            o.normal = v.normal;
            o.texcoord = v.texcoord;
            return o;
        }
        //控制曲面细分
        UnityTessellationFactors hsconst (InputPatch<t2v,3> i) 
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
        t2v main_h(InputPatch<t2v,3> v, uint id : SV_OutputControlPointID) 
        {
            return v[id];
        }
        [UNITY_domain("tri")]
        v2f main_d(UnityTessellationFactors tessFactors,const OutputPatch<t2v,3> i,float3 bary:SV_DomainLocation) 
        {
            a2v v;
            v.vertex = i[0].vertex*bary.x + i[1].vertex*bary.y + i[2].vertex*bary.z;
            v.normal = i[0].normal*bary.x + i[1].normal*bary.y + i[2].normal*bary.z;
            v.texcoord = i[0].texcoord*bary.x + i[1].texcoord*bary.y + i[2].texcoord*bary.z;
            v2f o = vert(v);
            return o;
        }
        [UNITY_domain("tri")]
        v2f_back main_d_back(UnityTessellationFactors tessFactors,const OutputPatch<t2v,3> i,float3 bary:SV_DomainLocation) 
        {
            a2v v;
            v.vertex = i[0].vertex*bary.x + i[1].vertex*bary.y + i[2].vertex*bary.z;
            v.normal = i[0].normal*bary.x + i[1].normal*bary.y + i[2].normal*bary.z;
            v.texcoord = i[0].texcoord*bary.x + i[1].texcoord*bary.y + i[2].texcoord*bary.z;
            v2f_back o = vert_back(v);
            return o;
        }
        ENDCG

        GrabPass
		{
			"_GrabTempTex"
        }
        pass
        {
            Cull Front
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #pragma hull main_h
            #pragma domain main_d_back
            fixed4 _OutlineColor;
            fixed4 main_f(v2f i):SV_TARGET
            {
                return _OutlineColor;
            }
            ENDCG
        }
        pass
        {
            Cull Back
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #pragma hull main_h
            #pragma domain main_d
            sampler2D _GrabTempTex;
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 normal_dir = normalize(i.world_normal);
                fixed3 view_dir = normalize(UnityWorldSpaceViewDir(i.world_pos));
                fixed3 light_dir  = normalize(UnityWorldSpaceLightDir(i.world_pos));
                fixed3 reflect_dir = normalize(reflect(-view_dir, normal_dir));
                fixed nv = dot(view_dir,normal_dir);
                fixed nl = dot(normal_dir,light_dir);
                // color = DecodeHDR(color, unity_SpecCube0_HDR)
                //混合漫反射以及镜面反射
                fixed3 color = 0;
                fixed3 height = tex2D(_HeigthTex,i.uv).r;
                //根据深度值改变漫反射
                fixed4 grab_color = tex2Dproj(_GrabTempTex,i.grab_uv + float4(tex2D(_NoiseTex,i.uv) * _RefractAmount));
                grab_color.rgb = lerp(_Color,grab_color.rgb,grab_color.a);
                fixed3 refract_color = lerp(grab_color,_Color,0.9);
                fixed3 diffuse_color = _LightColor0.rgb * refract_color * saturate(nl * _HalfDiffuse + (1 - _HalfDiffuse));
                // refract_color = _Color;
                fixed3 reflect_color = DecodeHDR(UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflect_dir, 0), unity_SpecCube0_HDR);
                fixed3 fre = _FresnelStrenth * Fresnel(_Color,nv);
                color = ((1 - fre) * diffuse_color + reflect_color * fre);
                //气泡效果
                return fixed4(color,1);
            }
            ENDCG
        }
    }
}