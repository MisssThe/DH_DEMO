// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/CartoonShader"
{
    Properties
    {
        _MainTex ("Main Texture",2D) = ""{}
        _Color ("Color",Color) = (1,1,1,1)
        _OutlineColor ("Outline Color",Color) = (1,1,1,1)
        _OutlineStrenth ("Outline Strenth",Float) = 0
        _SpecularThreshold ("Specular Threshold",Range(0,1)) = 0
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
        }
        CGINCLUDE
        #pragma shader_feature FRONT_ON BACK_ON
        #include "Tools.cginc"
        struct a2v
        {
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float4 texcoord:TEXCOORD0;
        };
        struct v2f_back
        {
            float4 pos:SV_POSITION;
        };
        struct v2f_front
        {
            float4 pos:SV_POSITION;
            float2 uv:TEXCOORD0;
            float3 world_normal:TEXCOORD1;
            float3 world_pos:TEXCOORD2;
        };
        fixed4 _OutlineColor;
        fixed _SpecularThreshold;
        half _OutlineStrenth;
        fixed4 _Color;
        v2f_back main_v_back(a2v i)
        {
            v2f_back o;
            float3 view_pos = UnityObjectToViewPos(i.vertex);
            float3 view_normal = mul(UNITY_MATRIX_IT_MV,i.normal);
            view_normal.z = -0.5;
            view_pos += view_normal * _OutlineStrenth;
            o.pos = UnityViewToClipPos(view_pos);
            return o;
        }
        fixed4 main_f_back(v2f_back i):SV_TARGET
        {
            return _OutlineColor;
        }
        v2f_front main_v_front(a2v i)
        {
            v2f_front o;
            o.pos = UnityObjectToClipPos(i.vertex);
            o.world_normal = UnityObjectToWorldNormal(i.normal);
            o.world_pos = mul(unity_ObjectToWorld,i.vertex);
            o.uv = TRANSFORM_TEX(i.texcoord,_MainTex);
            return o;
        }
        fixed4 main_f_front(v2f_front i):SV_TARGET
        {
            fixed3 color = 0;
            fixed3 light_dir = UnityWorldSpaceLightDir(i.world_pos);
            fixed3 view_dir = UnityWorldSpaceViewDir(i.world_pos);
            fixed3 normal_dir = normalize(i.world_normal);
            fixed nl = dot(normal_dir,light_dir);
            fixed nv = dot(normal_dir,view_dir);
            fixed3 diffuse = _LightColor0.rgb * tex2D(_MainTex,i.uv) * _Color.rgb * saturate(nl);
            return fixed4(diffuse,_Color.a);
        }
        ENDCG
        pass//描边效果
        {
            Cull Front
            CGPROGRAM
            #ifdef FRONT_ON
            #pragma vertex main_v_back
            #pragma fragment main_f_back
            #endif
            #ifdef BACK_ON
            #pragma vertex main_v_front
            #pragma fragment main_f_front
            #endif
            ENDCG
        }
        pass//表面渲染
        {
            Cull Back
            CGPROGRAM
            #ifdef FRONT_ON
            #pragma vertex main_v_front
            #pragma fragment main_f_front
            #endif
            #ifdef BACK_ON
            #pragma vertex main_v_back
            #pragma fragment main_f_back
            #endif
            ENDCG
        }  
    }
}
