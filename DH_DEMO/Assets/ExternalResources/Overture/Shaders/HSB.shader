Shader "AE/Overture/HSB"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LuminosityAmount ("饱和度", Range(0, 10)) = 1
        _Contrast ("对比度", Range(0, 10)) = 1
        _Brightness ("明度", Range(0, 2)) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _LuminosityAmount;
            float _Contrast;
            float _Brightness;

            fixed4 frag (v2f i) : SV_Target
            {
                // fixed4 col = tex2D(_MainTex, i.uv);
                // // just invert the colors
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                float luminosity = 0.299 * renderTex.r + 0.587 * renderTex.g + 0.114 * renderTex.b;
                fixed4 col = lerp(renderTex, luminosity, 1 - _LuminosityAmount);
                // 对比度
                col = lerp(col, fixed4(0.5, 0.5, 0.5, renderTex.a), 1 - _Contrast);
                // 明度
                col = col * _Brightness;


                return col;
                // col.rgb = 1 - col.rgb;
                // return col;
            }
            ENDCG
        }
    }
}
