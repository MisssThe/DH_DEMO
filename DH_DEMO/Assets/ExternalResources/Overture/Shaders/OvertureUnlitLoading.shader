Shader "Overture/Unlit/Loading" {
Properties {
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    _Color ("颜色", Color) = (255, 255, 255, 255)
    _Speed ("帧率", Float) = 1
    _WidHei ("动画帧宽高", Vector) = (1, 1, 0, 0)
}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 100

    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha

    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 _WidHei;
            float _Speed;
            fixed4 _Color;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);

                int F = floor(_Time.x * _Speed * 100);
                F = fmod(F, _WidHei.x * _WidHei.y);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.texcoord.x = _WidHei.x == 0 ? _WidHei.x : v.texcoord.x / _WidHei.x + F / _WidHei.x;
                o.texcoord.y = _WidHei.y == 0 ? _WidHei.y : v.texcoord.y / _WidHei.y + floor(F/ _WidHei.x) / _WidHei.y;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
                UNITY_APPLY_FOG(i.fogCoord * 2, col);
                clip(tex2D(_MainTex, i.texcoord).a - 0.5);
                return col;
            }
        ENDCG
    }
}

}
