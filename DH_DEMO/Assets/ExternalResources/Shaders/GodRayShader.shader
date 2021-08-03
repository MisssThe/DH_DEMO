Shader "Custom/GodRayShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        pass
        {
            Tags
            {
                "RenderType" = "Opaque"
            }
            CGPROGRAM
            #include "Tool.cginc"
            #pragma vertex main_v
            #pragma fragment main_f
            struct a2v
            {
                float4 vertex:POSITION;
                float4 tecoord:TEXCOORD0;
            };
            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            v2f main_v(a2v i)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.uv = TRANSFORM_TEX(i.texcoord,_MainTex);
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 color = tex2D(_MainTex,i.uv);

                return fixed4(color,1);
            }
            ENDCG
        }
    }
}
