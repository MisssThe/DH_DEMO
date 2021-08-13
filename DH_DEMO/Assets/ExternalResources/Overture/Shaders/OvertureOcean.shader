Shader "Overture/OvertureOcean"
{
    Properties
    {
        [HideInInspector] _ReflectionTex ("", 2D) = "white" {}
		// [HideInInspector] _ReflectionBlockTex ("", 2D) = "white" {}
		[HideInInspector] _HeightMap ("", 2D) = "black" {}
		// [HideInInspector] _ShadowMask ("", 2D) = "white" {}

        [Header(Textures)]
		_WaterBackground ("水底", 2D) = "white" {} 
		_FoamTex ("泡沫贴图", 2D) = "white" {} 
		_NormalTex ("法线贴图", 2D) = "white" {}
		_ShallowMaskOffset("Shallow Mask Offset",Vector) = (-0.1,0.2,0,0)
		_Skybox("天空盒(用于折射反射)", Cube) = "" {}
		_NormalSpeed("法线移动速度", Float) = 1.0

        // _HeightMapTransform("高度图在 xz 轴上的缩放",Vector) = (640,640,0.3,0.3)

        [Header(Scattering Color)]
		_DeepColor("深度颜色", Color) = (0.04,0.125,0.62,1.0)
		_ShallowColor("阴影颜色", Color) = (0.275,0.855,1.0,1.0)

        [Header(Refractive Distortion)]
		_RefractionStrength("折射变形强度",Float) = 1.0
		_WaterClarity("水体浑浊率",Range(4,30)) = 12.0
		_WaterClarityAttenuationFactor("水体浑浊率衰减因子",Range(0.1,3)) = 1.0
		_WaterDepthChangeFactor("水体深度因子",Range(-2,2)) = 1.0
		_WaterEdgeogHeightAndLow("水位线透明度", Range(0, 1)) = 0.5

        [Header(Fake SSS)]
		_DirectTranslucencyPow("直接次表面反射强度",Range(0.1,3)) = 1.5
		_EmissionStrength("半透明程度",Range(0.1,2)) = 1.0
		_DirectionalScatteringColor("半透明颜色", Color) = (0.00,0.65,0.34,1.0)
		_waveMaxHeight("高度影响因子", Float) = 5.0

        [Header(Reflective)]
		[Toggle(_USE_SKYBOX)] _UseSkybox ("是否只使用天空盒", Float) = 0
		_AirRefractiveIndex("空气折射因子", Float) = 1.0
		_WaterRefractiveIndex("水体折射因子", Float) = 1.333
		_FresnelPower("分型因子", Range(0.1,50)) = 5
		_ReflectionDistortionStrength("折射扰动",Float) = 1.0
		_ReflectionAlpha("反射强度", Range(0, 1)) = 0.5

        [Header(Specular)]
		_SunAnglePow("阳光角度影响因子", Range(0.1,2)) = 1
		_Shininess("高光",Range(50,800)) = 400
    }
    SubShader
    {
       Tags { "RenderType"="Transparent" "RenderQueue"="Transparent" "LightMode"="ForwardBase" }

		// 获取折射的背景
		// GrabPass { "_WaterBackground" }
		Pass{
	            CGPROGRAM
	            #pragma shader_feature _USE_SKYBOX
	            #pragma vertex vert
	            #pragma fragment frag
	            #pragma multi_compile_fwdbase
	            #include "UnityCG.cginc"
	            #include "autolight.cginc"
	            #include "lighting.cginc"

	            samplerCUBE _Skybox;                // 天空盒
	            sampler2D _FoamTex;                 // 泡沫贴图
	            sampler2D _NormalTex;               // 法线贴图
	            sampler2D _WaterBackground;         // 水底
	            sampler2D _CameraDepthTexture;      // 相机深度图
	            sampler2D _ReflectionTex;           // 反射贴图
	            // sampler2D _ReflectionBlockTex;      // 反射剔除贴图
	            sampler2D _HeightMap;               // 高度图
	            sampler2D _ShadowMask;              // 阴影贴图
	            sampler2D _FoamMap;                 // 泡沫映射？

	            float4 _FoamTex_ST;                 // 泡沫贴图的变换
	            float4 _NormalTex_ST;               // 法线贴图的变换
				float _ReflectionAlpha;

                // 这堆是C#传过来的数据
                // ---------------------------------------------------------------------------
				float _S;
				float _A1,_A2,_A3,_A4,_A5,_A6,_A7,_A8,_A9,_A10,_A11,_A12;
				float _Stp1,_Stp2,_Stp3,_Stp4,_Stp5,_Stp6,_Stp7,_Stp8,_Stp9,_Stp10,_Stp11,_Stp12;
				float _D1,_D2,_D3,_D4,_D5,_D6,_D7,_D8,_D9,_D10,_D11,_D12;
                // ---------------------------------------------------------------------------

				float4 _DeepColor;                      // 深度颜色
				float4 _ShallowColor;                   // 阴影颜色
				float4 _DirectionalScatteringColor;     // 水体颜色

				float4 _CameraDepthTexture_TexelSize;   // 相机深度贴图纹素大小

				float _Shininess;                       // 亮度
				float _SunAnglePow;                     // 阳光角度因子
				float _NormalSpeed;                     // 法线贴图
				float _ShoreWaveAttenuation;            // 短波衰减
				float _AirRefractiveIndex;              // 空气折射因子
				float _WaterRefractiveIndex;            // 水体折射因子
				float _FresnelPower;                    // 分型参数
				float _RefractionStrength;              // 折射强度
				float _WaterClarity;                    // 水体浑浊度
				float _WaterDepthChangeFactor;          // 水体深度影响因子
				float _WaterClarityAttenuationFactor;   // 水体浑浊度衰减因子
				float _DirectTranslucencyPow;           // 半透明度
				float _EmissionStrength;                // 次表面反射强度
				float _waveMaxHeight;                   // 高度影响因子
				float _ReflectionDistortionStrength;    // 反射失真程度
				float _WaterEdgeogHeightAndLow;

				int _resolution;                        // 

				float2 _ShallowMaskOffset;              // 阴影贴图偏移

				// 波形位移采样器(来自计算着色器)
				struct waveSampler
				{
					float x;
					float z;
					float3 displacement;
				};

                // 顶点着色器输入
	            struct vertexInput
	            {
	                float4 vertex : POSITION;
	                float3 normal : NORMAL;
	                float3 uv : TEXCOORD0;
	               

	            };

                // 顶点着色器输出
	            struct vertexOutput
	            {
	                float4 pos : SV_POSITION;
	                float2 uv : TEXCOORD0;
	                float3 worldPos : TEXCOORD1;
	                float4 grabPos : TEXCOORD2;
	            };

                // 新建一个结构体缓冲区
	            StructuredBuffer<waveSampler> displacementSample;

	            // 计算一个 gerstner 波的切法线(公式-?)
	            float3 SingleWaveB(float w, float Amp, float Stp, float Dir, float3 vert, float psi, float xScale, float zScale, float timeScale)
	            {
	            	float Dz, Dx;
	            	float Pi = 3.1415926f;
	            	sincos(Dir / 360  * 2 * Pi , Dz, Dx);
	            	float phase = w * Dx * vert.x * xScale + w * Dz * vert.z * zScale + psi * _Time.x * timeScale;
	            	float sinp;float cosp;
	            	sincos(phase, sinp, cosp);
	            	float3 dB = float3(0,0,0);
	            	dB.x = -Stp * Dx * Dx * sinp;
	            	dB.z = -Stp * Dx * Dz * sinp;
	            	dB.y = Amp * Dx * w * cosp;
	            	return dB;
	            }

	            // 计算一个 gerstner 波的切线(公式-?)
	            float3 SingleWaveT(float w, float Amp, float Stp, float Dir, float3 vert, float psi, float xScale, float zScale, float timeScale)
	            {
	            	float Dz, Dx;
	            	float Pi = 3.1415926f;
	            	sincos(Dir / 360  * 2 * Pi , Dz, Dx);
	            	float phase = w * Dx * vert.x * xScale + w * Dz * vert.z * zScale + psi * _Time.x * timeScale;
	            	float sinp;float cosp;
	            	sincos(phase, sinp, cosp);
	            	float3 dT = float3(0,0,0);
	            	dT.x = -Stp * Dx * Dz * sinp;
	            	dT.z = -Stp * Dz * Dz * sinp;
	            	dT.y = Amp * Dz * w * cosp;
	            	return dT;
	            }


	            // 将两个不同方向的 Gerstner 波相加(公式-?)
	            void CalculateGerstnerBT(float Amp, float Stp, float Dir, float Lth ,float attenuationFac,float3 vert,out float3 dB, out float3 dT)
	            {
	            	dB = 0; 
                    dT = 0;
	            	Stp *= 0.3;
	            	attenuationFac  = attenuationFac + (1 - attenuationFac)*sqrt(2/Lth);
	            	Amp = Amp * attenuationFac * Lth / 40 ;
	            	Stp =  (1-step(Amp,0)) * Stp;
	            	float Pi = 3.1415926f; 
                    float g = 9.8f;
	            	float Dx;
                    float Dz;
	            	sincos(Dir / 360  * 2 * Pi , Dz, Dx);
	            	float w =  2 * Pi / Lth;
	            	float psi = _S * 2 * Pi / 20 / sqrt(Lth);
	
					dB += SingleWaveB(w,Amp,Stp,Dir,vert,psi,1,1,3.5);
	            	dB += SingleWaveB(w,Amp*1.00,Stp,Dir+17,vert,psi,0.9,1,4);
	            	dB += SingleWaveB(w,Amp*0.95,Stp,Dir+46,vert,psi,1.1,0.9,4.5);
	            	dB += SingleWaveB(w,Amp*0.85,Stp,Dir+65,vert,psi,0.8,1.2,5);
	            	dB += SingleWaveB(w,Amp*0.75,Stp,Dir+133,vert,psi,1.4,0.8,5.5);
	            	dB += SingleWaveB(w,Amp*0.65,Stp,Dir+96,vert,psi,0.7,0.65,6);

	            	dT += SingleWaveT(w,Amp,Stp,Dir,vert,psi,1,1,3.5);
	            	dT += SingleWaveT(w,Amp*1.00,Stp,Dir+17,vert,psi,0.9,1,4);
	            	dT += SingleWaveT(w,Amp*0.95,Stp,Dir+46,vert,psi,1.1,0.9,4.5);
	            	dT += SingleWaveT(w,Amp*0.85,Stp,Dir+65,vert,psi,0.8,1.2,5);
	            	dT += SingleWaveT(w,Amp*0.75,Stp,Dir+133,vert,psi,1.4,0.8,5.5);
	            	dT += SingleWaveT(w,Amp*0.65,Stp,Dir+96,vert,psi,0.7,0.65,6);
	            }


	            // 将两个以切线-切法线形式表示的 Gerstener 波相加(公式-?)
	            void CalculateWaveBT(float3 vert, out float3 binormal, out float3 tangent, float attenuationFac)
	            {

	            	binormal = float3(1,0,0);
	            	tangent = float3(0,0,1);
	            	float3 dB;float3 dT;

	            	CalculateGerstnerBT(_A1,_Stp1,_D1,2,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A2,_Stp2,_D2,3,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A3,_Stp3,_D3,5,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A4,_Stp4,_D4,8,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A5,_Stp5,_D5,13,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A6,_Stp6,_D6,21,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A7,_Stp7,_D7,34,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A8,_Stp8,_D8,55,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A9,_Stp9,_D9,89,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A10,_Stp10,_D10,144,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A11,_Stp11,_D11,233,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;

	            	CalculateGerstnerBT(_A12,_Stp12,_D12,377,attenuationFac, vert, dB, dT);
	            	binormal.x += dB.x; binormal.z += dB.z; binormal.y += dB.y;
	            	tangent.x += dT.x; tangent.z += dT.z; tangent.y += dT.y;


	            	binormal = normalize(binormal);
	            	tangent = normalize(tangent);

	            	         	
	            }

	            // 计算分型因子
	            float CalculateFresnel (float3 I, float3 N)
	            {
	            	float R_0 = (_AirRefractiveIndex - _WaterRefractiveIndex) / (_AirRefractiveIndex + _WaterRefractiveIndex);
	            	R_0 *= R_0;
	            	return  R_0 + (1.0 - R_0) * pow((1.0 - saturate(dot(I, N))), _FresnelPower);
	            }

                // 对齐 Grab 的纹素
	            float2 AlignWithGrabTexel (float2 uv)
	            {
	            	return (floor(uv * _CameraDepthTexture_TexelSize.zw) + 0.5) * abs( _CameraDepthTexture_TexelSize.xy);
	            }

	            // **计算伪次表面散射**
                // -- lightDirection : 光线
                // -- worldNormal : 法线
                // -- viewDir : 视线
                // -- waveHeight : 波高度
                // -- shadowFactor : 阴影
	            float4 CalculateSSSColor(float3 lightDirection, float3 worldNormal, float3 viewDir,float waveHeight, float shadowFactor){
	            	// 计算光线的垂直强度(用根号下光线的垂直大小来表示)
                    float lightStrength = sqrt(saturate(lightDirection.y));
                    // **伪次表面散射因子的计算公式**
                    //   sss = ((viewDir · lightDirection + worldNormal · -lightDirection) ^ __DirectTranslucencyPow) * shadowFactor * lightStrength * _EmissionStrength
	            	float SSSFactor = pow(saturate(dot(viewDir ,lightDirection) )+saturate(dot(worldNormal ,-lightDirection)) ,_DirectTranslucencyPow) * shadowFactor * lightStrength * _EmissionStrength;
	            	// 该像素散射颜色
                    return _DirectionalScatteringColor * (SSSFactor + waveHeight * 0.6);
	            }

	            // **计算水体折射**
                // -- worldPos : 世界坐标
                // -- grabPos : 未正则化的屏幕坐标
                // -- worldNormal : 该像素的法线
                // -- viewDir : 视线
                // -- lightDirection : 光照方向
                // -- landHeight : 陆地高度
                // -- waveHeight : 波高度
                // -- shadowFactor : 阴影因子
	            float4 CalculateRefractiveColor(float3 worldPos, float2 UV, float4 grabPos, float3 worldNormal, float3 viewDir, float3 lightDirection,float landHeight,float waveHeight,float shadowFactor)
	            {
	            	// 水底深度
                    // SAMPLE_DEPTH_TEXTURE_PROJ : 从_CameraDepthTexture中采样深度值, 第二个参数是深度贴图对应相机的ScreenPos
                    // 这里的 LinearEyeDepth 把纹理的深度采样结果转换到相机空间中
	           		float backgroundDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, grabPos));
                    // 水面深度
	            	float surfaceDepth = grabPos.w;
                    // 没有扰动时的水的深度
	            	float viewWaterDepthNoDistortion = 100;// backgroundDepth - surfaceDepth;

                    // 折射图像的UV计算
	            	float4 distortedUV = grabPos;                           // 折射图像的原始UV
					distortedUV.xy = UV;
	            	float2 uvOffset = worldNormal.xz * _RefractionStrength; // 水面的法线和折射强度相乘, 组成UV的偏移量
					uvOffset *= saturate(viewWaterDepthNoDistortion);       // 规则化水的深度, 然后再乘上水的UV偏移
					distortedUV.xy = distortedUV.xy + uvOffset; 			// 将折射图像的UV与摄像机的纹素对齐

					// // 重采样深度
	            	// backgroundDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, distortedUV));
	            	// surfaceDepth = grabPos.w;
	            	float viewWaterDepth = backgroundDepth - surfaceDepth;

                    // // 如果水很浅的话考虑将未折射的图像与折射图像融合起来
                    // // ------------------------------------------------------------------------
					// float tmp = 1 - step(viewWaterDepth,0);
	            	// distortedUV.xy = tmp * UV/*AlignWithGrabTexel(grabPos.xy)*/ + (1 - tmp) * distortedUV.xy;
	            	// viewWaterDepth = tmp * viewWaterDepthNoDistortion + (1 - tmp) * viewWaterDepth;
                    // // ------------------------------------------------------------------------
	            	
                    // 采样颜色
                    // tex2Dproj : 在裁切空间下使用, 与tex2D的区别是会自动地将输入的 uv 统一除以 uv.w
	            	float4 transparentColor =  tex2D(_WaterBackground, distortedUV.xy + _Time.xy);// tex2Dproj(_WaterBackground , distortedUV);

                    // 计算水波与水深对颜色的影响
	            	float shallowWaterFactor = 0;
					shallowWaterFactor = _WaterDepthChangeFactor; //saturate(pow(landHeight, _WaterDepthChangeFactor));
					float4 scatteredColor = _DeepColor  + _ShallowColor * shallowWaterFactor * (shadowFactor + 1) * 0.5;

					float viewWaterDepthFactor = pow(saturate(viewWaterDepth / _WaterClarity), _WaterClarityAttenuationFactor);
					float x = saturate(viewWaterDepthFactor);
					viewWaterDepthFactor = 1-(cos(2*3.1415926*((x-1)*(x-1)*(x-1)) + 3.1415926)*0.5+0.5) * _WaterEdgeogHeightAndLow;

                    // 次表面散射
					float4 emissionSSSColor = CalculateSSSColor(lightDirection, worldNormal,  viewDir, waveHeight, shadowFactor);

                    // 返回水体的折射
	            	return lerp(transparentColor , scatteredColor, viewWaterDepthFactor) + emissionSSSColor;
	            }

	            // 计算反射颜色
	            float4 CalculateReflectiveColor(float3 worldPos, float4 grabPos, float3 worldNormal, float3 viewDir, out float4 distortedUV)
	            {
                    // 
	            	float2 uvOffset = worldNormal.xz * _ReflectionDistortionStrength;

                    // 
	            	uvOffset.y -= worldPos.y;
	            	distortedUV = grabPos; distortedUV.xy += uvOffset;
	            	#if _USE_SKYBOX	
	            		return texCUBE(_Skybox, reflect(viewDir,worldNormal));
	            	#endif
	            	float4 skyColor = texCUBE(_Skybox, reflect(viewDir,worldNormal));
	            	return lerp(tex2Dproj(_ReflectionTex, UNITY_PROJ_COORD(distortedUV)),skyColor,0.65);
	            }

	            vertexOutput vert(vertexInput input)
	            {
	                vertexOutput output;

					float3 worldPos = mul(unity_ObjectToWorld, input.vertex);

					// 从计算着色器读取顶点位移信息
					int x = round(input.uv.x * (_resolution - 1));
					int z = round(input.uv.y * (_resolution - 1));
					int index =  x * _resolution + z;
                    // displacementSample 采样了顶点的偏移量
					float3 disPos = displacementSample[index].displacement;

					input.vertex.xyz = mul(unity_WorldToObject, float4(worldPos + disPos, 1));
					worldPos = worldPos + disPos;
					output.uv = input.uv;
    				output.pos = UnityObjectToClipPos(input.vertex);

    				output.worldPos = worldPos;
    				output.grabPos = ComputeGrabScreenPos(output.pos);
	                return output;
	            }

	            float4 frag(vertexOutput input) : SV_Target
	            {
	            	float3 viewDir = normalize(input.worldPos - _WorldSpaceCameraPos.xyz);

	            	// 从高度图采样陆地高度
                    // ---------------------------------------------------------------------------
	            	float landHeight = tex2D(_HeightMap, float2(input.worldPos.x/1200+0.25, input.worldPos.z/1200+0.25));
	            	float attenuationFac = 1;
	            	// 浅水区的波浪衰减
					attenuationFac = saturate(pow((1.0 - landHeight),_ShoreWaveAttenuation));
                    // ---------------------------------------------------------------------------

                    // 计算波的切线\切法线和法线
                    // ---------------------------------------------------------------------------
	            	float3 bitangent = float3(0,0,0);
	            	float3 tangent = float3(0,0,0);
	            	CalculateWaveBT(input.worldPos, bitangent, tangent, attenuationFac);
	            	float3 worldNormal = normalize(cross(tangent, bitangent));

                    // 构造TBN矩阵, 将法线贴图从切线空间变换到模型空间
                    // 并采样法线贴图
	            	float3x3 M = {bitangent,tangent,worldNormal};
	            	M = transpose(M);
	            	float3 tangentNormal = lerp(UnpackNormal(tex2D(_NormalTex, float2(input.worldPos.x / 50.0 * _NormalTex_ST.x,input.worldPos.z / 50.0 * _NormalTex_ST.y) + float2(0.94,0.34)*_Time.x*_NormalSpeed)),
	            								UnpackNormal(tex2D(_NormalTex, float2(input.worldPos.x / 50.0 * _NormalTex_ST.x,input.worldPos.z / 50.0 * _NormalTex_ST.y) + float2(-0.85,-0.53)*_Time.x*_NormalSpeed)),0.5);
	            	tangentNormal = normalize(tangentNormal);
	            	float3 mappedWorldNormal = normalize(mul(M, tangentNormal));    // 采样到的法线
                    // ----------------------------------------------------------------------------

                    // 波的高度
	            	float waveHeight = saturate(input.worldPos.y/_waveMaxHeight) ;

                    // 光线
	            	float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

                    // 高光用 Phong 模型
					float3 specularColor = pow(max(0.0, dot(reflect(lightDirection, mappedWorldNormal),viewDir)), _Shininess);

					// 计算反射颜色
                    // ----------------------------------------------------------------------------
					float4 reflectiveDistortedUV;
                    // 这个函数 返回反射颜色, 并输出反射扰动的UV
					float3 reflectedColor = CalculateReflectiveColor(input.worldPos, input.grabPos, mappedWorldNormal,viewDir,reflectiveDistortedUV);
					reflectiveDistortedUV.x = input.grabPos.x;
                    // ----------------------------------------------------------------------------

					// 阴影贴图来一张
					float shadowFactor = tex2Dproj(_ShadowMask, UNITY_PROJ_COORD(reflectiveDistortedUV));

					// 反射剔除
					// float blockFactor = saturate(1-tex2Dproj(_ReflectionBlockTex, UNITY_PROJ_COORD(reflectiveDistortedUV)).r);

                    // 计算分型因子?
					float F = CalculateFresnel (-viewDir, mappedWorldNormal);

                    // 计算折射
					float4 refractiveColor = CalculateRefractiveColor(input.worldPos, input.uv, input.grabPos, mappedWorldNormal,viewDir,lightDirection,landHeight,waveHeight,shadowFactor);

                    // 混合颜色并返回 --------------------------------------------------------------
					float4 col = float4(lerp(refractiveColor ,reflectedColor , F * _ReflectionAlpha),1) + float4(specularColor,1) * shadowFactor; //* blockFactor;
	                return col;
	            }
	            ENDCG
		}
	}

	FallBack "Specular"
}
