// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/AttackShader"
{
    Properties
    {
        _MainTex ("Main Texture",2D) = ""{}
        _Alpha ("Alpha",Range(0,1)) = 0
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True" 
        }
        pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite off
            Cull off
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
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Alpha;
            v2f main_v(a2v i)
            {
                v2f o;
                float3 center_world_pos = mul(unity_ObjectToWorld,float4(0,0,0,1));
                float3 world_normal = UnityObjectToWorldNormal(i.normal);
                fixed3 dir = -UnityWorldSpaceViewDir(center_world_pos);
                fixed _cos = dot(normalize(world_normal).xz,normalize(dir).xz);
                fixed _sin = sqrt(1 - _cos * _cos);
                if (dir.x > 0)
                {
                    _sin = -_sin;
                }
                float4x4 rotation_matrix =  float4x4(
                    _cos ,0   ,_sin ,0,
                    0    ,1   ,0    ,0,
                    -_sin,0   ,_cos ,0,
                    0    ,0   ,0    ,1
                    );
                i.vertex = mul(rotation_matrix,i.vertex);
                o.pos = UnityObjectToClipPos(i.vertex);
                o.uv = TRANSFORM_TEX(i.texcoord,_MainTex);
                return o;
            }
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed4 color = tex2D(_MainTex,i.uv);
                clip(0.5 - color.g);
                clip(color.a - 0.1);
                return fixed4(color.rgb,_Alpha);
            }
            ENDCG
        }
    }
}
