// 启动后随时间扩散
Shader "Custom/BackMagicShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture",2D) = ""{}
        _Speed ("Speed",float) = 0
        _InitTime ("Init Time",float) = 0
    }
    SubShader
    {
        // pass
        // {
        //     ZWrite On 
        //     ColorMask a 
        //     CGPROGRAM
        //     #pragma vertex main_v
        //     #pragma fragment main_f
        //     struct a2v
        //     {
        //         float4 vertex:POSITION;
        //     };
        //     struct v2f
        //     {
        //         float4 pos:SV_POSITION;
        //     };
        //     v2f main_v(a2v i)
        //     {
        //         v2f o;
        //         o.pos = UnityObjectToClipPos(i.vertex);
        //         return o;
        //     }
        //     fixed4 main_f(v2f i):SV_TARGET
        //     {
        //         return fixed4(1,1,1,1);
        //     }
        //     ENDCG
        // }
        pass
        {
            Tags
            { 
                "RenderType"="Transparent"
                "Queue" = "Transparent"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest On
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
            float _InitTime;
            half _Speed;
            v2f main_v(a2v i)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(i.texcoord,_MainTex);
                o.pos = UnityObjectToClipPos(i.vertex);
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 color = tex2D(_MainTex,i.uv);
                clip(0.1 - color.r);
                _Color.a = (_Time.y - _InitTime);
                return _Color;
            }
            ENDCG
        }
    }
}
