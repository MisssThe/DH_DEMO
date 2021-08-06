/*
    使用几何着色器扩散物体
*/
Shader "Custom/CardSeaEffect"
{
    Properties
    {
        _NoiseTex ("Noise Texture",2D) = ""{}
        _Threshold ("Threshold",Range(0,1)) = 0
    }
    SubShader
    {
        pass
        {
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #pragma geometry main_g
            #include "Lighting.cginc"
            struct a2v
            {
                float4 pos:POSITION;
                float3 normal:NORMAL;
                float4 texcoord:TEXCOORD1;
            };
            struct v2g
            {
                float4 pos:SV_POSITION;
                float3 normal:TEXCOORD0;
                float4 texcoord:TEXCOORD1;
            };
            struct g2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD1;
            };
            sampler2D _NoiseTex;
            fixed _Threshold;
            float4 _NoiseTex_ST;
            v2g main_v(a2v i)
            {
                v2g o;
                o.pos = UnityObjectToClipPos(i.pos);
                o.normal = UnityObjectToWorldNormal(i.normal);
                o.texcoord = i.texcoord;
                return o;
            }
            [maxvertexcount(10)]
            void main_g(triangle v2g p[3], inout LineStream<g2f> stream) 
            {
                //采样随机图决定是否显示
				g2f o;
                fixed noise;
                o.uv = TRANSFORM_TEX(p[0].texcoord,_NoiseTex);
                fixed c = tex2Dlod(_NoiseTex,float4(o.uv,0,0));
                if (c < 0.5){
				o.pos = p[0].pos;
                // float l = 10;
				stream.Append(o);

				o.pos = p[1].pos;
                o.uv = TRANSFORM_TEX(p[1].texcoord,_NoiseTex);
                stream.Append(o);

				o.pos = p[2].pos;
                o.uv = TRANSFORM_TEX(p[2].texcoord,_NoiseTex);
                stream.Append(o);
                }
            }
            fixed4 main_f(g2f i):SV_TARGET
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
