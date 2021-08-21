// 启动后随时间扩散
Shader "Custom/MagicShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture",2D) = ""{}
        _X ("X",Range(-1,1)) = 0
        _Y ("Y",Range(-1,1)) = 0
        _Speed ("Speed",float) = 0
        _InitTime ("Init Time",float) = 0
    }
    SubShader
    {
        pass
        {
            Tags { "RenderType"="Transparent" }
            ZWrite Off
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
            fixed4 _Color;
            half _Speed;
            half _X;
            half _Y;
            float _InitTime;
            v2f main_v(a2v i)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(i.texcoord,_MainTex);
                o.pos = UnityObjectToClipPos(i.vertex);
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 color = tex2D(_MainTex,i.uv + fmod((_Time.y - _InitTime) * _Speed * half2(_X,_Y),0.4) - half2(_X,_Y) * 0.2);
                clip(0.1 - color.r);
                return _Color;
            }
            ENDCG
        }
    }
}
