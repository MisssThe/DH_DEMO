Shader "Custom/AttributeShader"
{
    Properties
    {
        _ColorMask ("Color Mask", Color) = (1,1,1,1)
        _MainTex ("Main Texture",2D) = ""{}
        _Percent ("Percent",Float) = 0
    }
    SubShader
    {
        Tags
        { 
            "RenderType"="Transparent"
            "RenderQueue" = ""
        }
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
                float4 color:COLOR;
            };
            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
                float4 color:TEXCOORD1;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _ColorMask;
            half _Percent;
            v2f main_v(a2v i)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.uv = TRANSFORM_TEX(i.texcoord,_MainTex);
                o.color = i.color;
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed4 color = tex2D(_MainTex,i.uv);
                if (color.g > 0.5)
                {
                    clip(_Percent - i.uv.y);
                    clip(0.8 - color.g);
                    color = i.color;
                }
                return color;
            }
            ENDCG
        }
    }
}
