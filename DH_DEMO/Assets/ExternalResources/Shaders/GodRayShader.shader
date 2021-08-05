Shader "Custom/GodRayShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _BloomThreshold ("Bloom Threshold",Range(0,1)) = 0
        _RadialBlurAmount ("Radial Blur Amount",Range(0,0.1)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }
        CGINCLUDE
        #include "Tools.cginc"
        struct a2v
        {
            float4 vertex:POSITION;
            float4 texcoord:TEXCOORD0;
        };
        struct v2f
        {
            float4 pos:SV_POSITION;
            float2 uv:TEXCOORD0;
        };
        v2f main_v(a2v i)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(i.vertex);
            o.uv = TRANSFORM_TEX(i.texcoord,_MainTex);
            return o;
        }
        ENDCG
        pass
        {
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 color = Bloom(i.uv);
                return fixed4(color,1);
            }
            ENDCG
        }
        pass
        {
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 color = RadialBlur(6,i.uv); 
                // fixed3 color = Bloom(i.uv);
                return fixed4(color,1);
            }
            ENDCG
        }
        pass
        {
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 color = RadialBlur(6,i.uv); 
                // fixed3 color = Bloom(i.uv);
                return fixed4(color,1);
            }
            ENDCG
        }
    }
}
