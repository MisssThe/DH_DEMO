Shader "Custom/RainShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RainTex ("Rain Texture",2D) = ""{}
        _Speed ("Speed",float) = 0
        _AO ("AO",Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
                float4 uv:TEXCOORD0;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _RainTex;
            float4 _RainTex_ST;
            fixed _AO;
            half _Speed;
            v2f main_v(a2v i)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.uv.xy = TRANSFORM_TEX(i.texcoord,_MainTex);
                o.uv.zw = TRANSFORM_TEX(i.texcoord,_RainTex);
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 base_color = tex2D(_MainTex,i.uv.xy);
                fixed3 rain_color = tex2D(_RainTex,i.uv.zw + fixed2(0,1) * _Time.y * _Speed);
                return fixed4(base_color * _AO + rain_color,1);
            }
            ENDCG
        }
    }
}
