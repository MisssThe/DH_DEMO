Shader "Custom/GetDepthTexture"
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
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #include "Lighting.cginc"
            struct a2v
            {
                float4 vertex:POSITION;
            };
            struct v2f
            {
                float4 pos:SV_POSITION;
            };
            sampler2D _CameraDepthTexture;
            v2f main_v(a2v i)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
