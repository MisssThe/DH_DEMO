// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

/*
    模拟海面效果
    使用顶点偏移+法线重构模拟海浪效果（可预计算到纹理上）,使用细分着色提升效果
    采样一个噪声提升波浪细节
*/
Shader "Custom/WalterEffect"
{
    Properties
    {
        //控制海浪属性
        _Cycle ("Cycle",Float) = 0
        _Height ("Height",Float) = 0
        _Speed1 ("Speed 1",Float) = 1
        _Speed2 ("Speed 2",Float) = 1
        _NoiseTex ("Noise Texture",2D) = ""{}
        _NoiseStrenth ("Noise Strenth",float) = 0
        _TessStrenth ("Tessellation Strenth",Float) = 0
        _TessMax ("Tessellation Max",Float) = 0
        //控制海面属性
        _Color ("Color",Color) = (1,1,1,1)
        _HeigthTex ("Heigth Texture",2D) = ""{}
    }
    SubShader
    {
        CGINCLUDE
        #include "Tools.cginc"
        //structure 
        struct a2v
        {
            float4 vertex:POSITION;
            float3 normal:NORMAL;
            float4 texcoord:TEXCOORD0;
        };
        struct t2v 
        {
            float4 vertex : INTERNALTESSPOS;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
        };
        struct v2f
        {
            float4 pos:SV_POSITION;
            float3 world_normal:TEXCOORD1;
            float3 world_pos:TEXCOORD2;
            float2 uv:TEXCOORD0;
        };
        //element
        half _Height;
        half _Cycle;
        half _Speed1;
        half _Speed2;
        fixed4 _F0;
        half _TessStrenth;
        half _TessMax;
        sampler2D _NoiseTex;
        float4 _NoiseTex_ST;
        float _NoiseStrenth;
        fixed4 _Color;
        sampler2D _HeigthTex;
        
        //function
        v2f vert(a2v i)
        {
            v2f o;
            o.uv = TRANSFORM_TEX(i.texcoord,_NoiseTex);
            fixed noise =  tex2Dlod(_NoiseTex,float4(o.uv + fixed2(TIME * _Speed1,0),1,1));            
            SinValue sv;
            sv.A = _Height;
            sv.B = _Cycle;
            sv.C = 0;
            i.vertex.xyz += offsetBySin(i.vertex.xyz + TIME * _Speed2,fixed3(0,1,0),sv);
            i.vertex.y += noise * _NoiseStrenth;
            o.pos = UnityObjectToClipPos(i.vertex);
            o.world_normal = UnityObjectToWorldNormal(i.normal);
            o.world_pos = mul(unity_ObjectToWorld,i.vertex);
            return o;
        }
        t2v main_v(a2v v) {
            t2v o;
            o.vertex = v.vertex;
            o.normal = v.normal;
            o.texcoord = v.texcoord;
            return o;
        }
        //控制曲面细分
        UnityTessellationFactors hsconst (InputPatch<t2v,3> i) 
        {
            UnityTessellationFactors o;
            //根据摄像机距离计算细分因子
            // float4 factor = _WorldSpaceCameraPos - UnityObjectToClipPos();
            float factor = 1;
            float3 dis = _WorldSpaceCameraPos - UnityObjectToClipPos(i[0].vertex);
            factor = _TessMax - (abs(dis.x) + abs(dis.y) + abs(dis.z)) * _TessStrenth;
            o.edge[0] = factor; 
            o.edge[1] = factor; 
            o.edge[2] = factor; 
            o.inside = factor;
            return o;
        }
        [UNITY_domain("tri")]
        [UNITY_partitioning("fractional_odd")]
        [UNITY_outputtopology("triangle_cw")]
        [UNITY_patchconstantfunc("hsconst")]
        [UNITY_outputcontrolpoints(3)]
        t2v main_h(InputPatch<t2v,3> v, uint id : SV_OutputControlPointID) 
        {
            return v[id];
        }
        [UNITY_domain("tri")]
        v2f main_d(UnityTessellationFactors tessFactors,const OutputPatch<t2v,3> i,float3 bary:SV_DomainLocation) 
        {
            a2v v;
            v.vertex = i[0].vertex*bary.x + i[1].vertex*bary.y + i[2].vertex*bary.z;
            v.normal = i[0].normal*bary.x + i[1].normal*bary.y + i[2].normal*bary.z;
            v.texcoord = i[0].texcoord*bary.x + i[1].texcoord*bary.y + i[2].texcoord*bary.z;
            v2f o = vert(v);
            return o;
        }
        ENDCG

        pass
        {
            CGPROGRAM
            #pragma vertex main_v
            #pragma fragment main_f
            #pragma hull main_h
            #pragma domain main_d
            fixed4 main_f(v2f i):SV_TARGET
            {
                fixed3 view_dir = normalize(UnityWorldSpaceViewDir(i.world_pos));
                fixed3 lightDir  = normalize(UnityWorldSpaceLightDir(i.world_pos));
                fixed3 reflect_dir = normalize(-reflect(lightDir,i.world_normal));
                fixed nv = dot(view_dir,i.world_normal);
                // color = DecodeHDR(color, unity_SpecCube0_HDR)
                //混合漫反射以及镜面反射
                fixed3 color = 0;
                fixed3 diffuse = fixed3(0,0,0);
                fixed3 specular = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflect_dir, 6);
                fixed3 fre = Fresnel(_Color,nv);
                float mip_roughness = 1;
                float3 reflectVec = reflect(-view_dir, i.world_normal);
                half mip = mip_roughness * UNITY_SPECCUBE_LOD_STEPS;
                specular = DecodeHDR(UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectVec, 0), unity_SpecCube0_HDR);
                color = diffuse + specular * fre;
                return fixed4(color,1);
            }
            ENDCG
        }
    }
}