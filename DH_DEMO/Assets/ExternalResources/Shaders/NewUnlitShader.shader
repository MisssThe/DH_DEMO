Shader "WaterEffect/Refract"
{
    Properties
    {
        _CubeMap("CubeMap", CUBE) = ""{}
        _RefractRatio("Refract Ratio", Float) = 0.5
        _FresnelScale("Fresnel Scale", Float) = 0.5
        _DistortTex("Distort Texture", 2D) = "" {}
        _DistortScale("Distort Scale", Float) = 0.05
    }
    SubShader
    {
        GrabPass{ "_GrabTex" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            struct appdata
            {
                float4 vertex : POSITION;   
                float2 uv : TEXCOORD0;          
                float3 normal : NORMAL;
            };
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldReflect : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float3 worldViewDir : TEXCOORD3;
                float4 vertexLocal : TEXCOORD4;
                float3 worldRefract : TEXCOORD5;
                float2 uv : TEXCOORD6;
                float2 screenUV : TEXCOORD7;
            };
            float _RefractRatio;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertexLocal = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = mul(unity_ObjectToWorld, v.normal);
                o.worldViewDir =  normalize(_WorldSpaceCameraPos.xyz - o.worldPos.xyz);
                o.worldReflect = reflect(-o.worldViewDir,normalize(o.worldNormal));
                o.worldRefract = refract(-o.worldViewDir,normalize(o.worldNormal),_RefractRatio);
                o.uv = v.uv;
                o.screenUV = (o.vertex.xy / o.vertex.w + 1)*0.5;
                return o;
            }
            sampler2D _GrabTex;
            float _FresnelScale;
            samplerCUBE _CubeMap;
            sampler2D _DistortTex;
            float _DistortScale;
            fixed4 frag (v2f i) : SV_Target
            {
                // 水的反射
                float4 fresnelReflectFactor = _FresnelScale + (1 - _FresnelScale)*pow(1-dot(i.worldViewDir,i.worldNormal), 5);
                fixed4 colReflect = texCUBE(_CubeMap, normalize(i.worldReflect));
                // 水的折射
                fixed4 colDistort = tex2D(_DistortTex, i.uv);
                float uvOffset = colDistort.r*_DistortScale;
                float2 sceneUV = i.screenUV.xy;//*0.5+0.5;
                sceneUV.y = 1-sceneUV.y;
                fixed4 colRefract = tex2D(_GrabTex,float2(sceneUV.x,sceneUV.y)+uvOffset);
                // 综合水的反射和水的折射
                fixed4 col = fresnelReflectFactor * colReflect + (1-fresnelReflectFactor) * colRefract;
                return float4(col.xyz,1);
            }
            ENDCG
        }
    }
}