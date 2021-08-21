// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/ShieldShader"
{
    Properties
    {
        _Color ("Color", Color) = (0.75,0.75,0.75,1)
        _Tex1 ("Texture1", 2D) = "white" {}
        _Speed1 ("Speed1",Float) = 0
        _Speed2 ("Speed2",Float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }
        pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #include "UnityCG.cginc"
            struct a2v
            {
                float4 vertex:POSITION;
                float4 texcoord:TEXCOORD0;
                float3 normal:NORMAL;
            };
            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
                float3 world_normal:TEXCOORD1;
                float3 world_pos:TEXCOORD2;
            };
            sampler2D _Tex1;
            float4 _Tex1_ST;
            half _Speed1;
            half _Speed2;
            fixed4 _Color;
            v2f main_v(a2v i)
            {
                v2f o;
                float _cos = cos(_Time.y * _Speed1);
                float _sin = sin(_Time.y * _Speed1);
                float4x4 rotation_matrix =  float4x4(
                    _cos ,0   ,_sin ,0,
                    0    ,1   ,0    ,0,
                    -_sin,0   ,_cos ,0,
                    0    ,0   ,0    ,1
                    );
                i.vertex = mul(rotation_matrix,i.vertex);
                o.pos = UnityObjectToClipPos(i.vertex);
                o.uv = TRANSFORM_TEX(i.texcoord,_Tex1);
                o.world_normal = UnityObjectToWorldNormal(i.normal);
                o.world_pos = mul(unity_ObjectToWorld,i.vertex);
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed4 color = fixed4(tex2D(_Tex1,i.uv).rgb,_Color.a);
                clip(0.4 - color.r);
                fixed n = lerp(0.3,1,fmod(i.uv.y + _Time.y * _Speed2,1));
                color.rgb = _Color.rgb * n;
                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
