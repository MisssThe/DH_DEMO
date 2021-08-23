Shader "Custom/DiffuseShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DiffusePower("Diffuse Power", Float) = 1.0
        _SpecularTex("Specular Tex", 2D) = "white"{}
        _Gloss("Specular Gloss", Float) = 0.5
        _SpecularColor("Specular Color", Color) = (1,1,1,1)

    }
    SubShader
    {

        Pass
        {
            Cull Off
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normalDir : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            sampler2D _MainTex;
            float _DiffusePower;
            sampler2D _SpecularTex;
            float _Gloss;
            float4 _SpecularColor;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normalDirection = normalize(i.normalDir);
                float lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 halfDirection = normalize(viewDirection+lightDirection);
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float NdotL = max(0,dot(normalDirection,lightDirection));
                float3 directionDiffuse = pow(NdotL, _DiffusePower) * attenColor;
                float3 inDirectionDiffuse = float3(0,0,0)+UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 texColor = tex2D(_MainTex, i.uv).rgb;
                float3 diffuseColor = texColor *(directionDiffuse+inDirectionDiffuse);
                float4 finalColor = float4(diffuseColor+ UNITY_LIGHTMODEL_AMBIENT.rgb * texColor * 2,1);
                return finalColor;
            }
            ENDCG
        }
    }
}