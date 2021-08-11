// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "UI/Overture/BottomCardsWave"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)

        // 自定义变量
        _AmWide("卡牌间隔", Range(0, 0.999)) = 0.01
        _Amplitude("振幅", Range(0, 0.999)) = 0.1
        _CycleWave("波浪周期", Float) = 0.2
        _CycleCard("卡牌周期", Range(0.0001, 1)) = 0.2
        _SpeedWave("波速度", Float) = 1
        _SpeedCard("卡速度", Float) = 1
        _OffsetCard("卡牌偏移", Range(0, 1)) = 0
        _OffsetWave("波形偏移", Float) = 0
        _OffsetUV("贴图偏移", Vector) = (0, 0, 1, 1)

        // 
        _AlphaBottom("透明度衰减(底部)", Range(0, 1)) = 0
        _AlphaTop("透明度衰减(顶部)", Range(0, 1)) = 0


        // 蒙版
        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255

        _ColorMask("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
    }

        SubShader
        {
            Tags
            {
                "Queue" = "Transparent"
                "IgnoreProjector" = "True"
                "RenderType" = "Transparent"
                "PreviewType" = "Plane"
                "CanUseSpriteAtlas" = "True"
            }

            Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
                ReadMask[_StencilReadMask]
                WriteMask[_StencilWriteMask]
            }

            Cull Off
            Lighting Off
            ZWrite Off
            ZTest[unity_GUIZTestMode]
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask[_ColorMask]

            Pass
            {
                Name "Default"
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0

                #include "UnityCG.cginc"
                #include "UnityUI.cginc"

                #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
                #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float4 color    : COLOR;
                    float2 texcoord : TEXCOORD0;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct v2f
                {
                    float4 vertex   : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 texcoord  : TEXCOORD0;
                    float4 worldPosition : TEXCOORD1;
                    half4  mask : TEXCOORD2;
                    UNITY_VERTEX_OUTPUT_STEREO
                };

                sampler2D _MainTex;
                fixed4 _Color;
                fixed4 _TextureSampleAdd;
                float4 _ClipRect;
                float4 _MainTex_ST;
                float _UIMaskSoftnessX;
                float _UIMaskSoftnessY;

                v2f vert(appdata_t v)
                {
                    v2f OUT;
                    UNITY_SETUP_INSTANCE_ID(v);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                    float4 vPosition = UnityObjectToClipPos(v.vertex);
                    OUT.worldPosition = v.vertex;
                    OUT.vertex = vPosition;

                    float2 pixelSize = vPosition.w;
                    pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                    float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                    float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                    OUT.texcoord = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                    OUT.mask = half4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                    OUT.color = v.color * _Color;
                    return OUT;
                }

                float _AmWide;
                float _Amplitude;
                float _CycleCard;
                float _CycleWave;
                float _SpeedCard;
                float _SpeedWave;
                float _OffsetCard;
                float _OffsetWave;
                float4 _OffsetUV;

                float _AlphaBottom;
                float _AlphaTop;

                fixed4 frag(v2f IN) : SV_Target
                {
                    // half4 color = IN.color * (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd);

                    // 裁切掉多余的部分
                    float texcX = (IN.texcoord.x  +  _Time.x * _SpeedCard);
                    float left_edge = floor(texcX / _CycleCard);
                    float offset = sin(left_edge * _CycleWave + _Time.x * _SpeedWave) * _Amplitude * 0.5 + _Amplitude * 0.5;
                    float2 uv_reCulc = 
                        float2(
                            texcX / _CycleCard - left_edge + _OffsetCard,
                            (IN.texcoord.y / (1 - _Amplitude) - offset)
                        );
                    uv_reCulc.x = uv_reCulc.x / (1 - _AmWide);
                    clip(1 - uv_reCulc.x);
                    clip(uv_reCulc.y);
                    clip(1 - uv_reCulc.y);

                    uv_reCulc.x = left_edge + uv_reCulc.x;
                    half4 color = IN.color * (tex2D(_MainTex, uv_reCulc * _OffsetUV.zw + _OffsetUV.xy) + _TextureSampleAdd);
                    color.a = _AlphaBottom == _AlphaTop ? color.a : color.a * saturate(
                        uv_reCulc.y * (1 / (_AlphaTop - _AlphaBottom)) +
                         -(1 / (_AlphaTop - _AlphaBottom)) * _AlphaBottom);
                    // color = half4(0, 0, 0, 1);
                    // color.x = uv_reCulc.y;


                    #ifdef UNITY_UI_CLIP_RECT
                    half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                    color.a *= m.x * m.y;
                    #endif

                    #ifdef UNITY_UI_ALPHACLIP
                    clip(color.a - 0.001);
                    #endif

                    return color;
                }
            ENDCG
            }
        }
}
