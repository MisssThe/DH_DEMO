﻿Shader "Custom/BaseUIShader"
{
    Properties
    {
        _MainTex ("Main Texture",2D) = ""{}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        pass
        {
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #include "UnityCG.cginc"
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
                fixed4 color = tex2D(_MainTex,i.uv);
                clip(color.a - 0.1);
                return color;
            }
            ENDCG
        }
    }
}