// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FAE/Tree Trunk"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "white" {}
		_GradientBrightness("GradientBrightness", Range( 0 , 2)) = 1
		_AmbientOcclusion("Ambient Occlusion", Range( 0 , 1)) = 0.5
		[Toggle]_UseLegacyVertexColors("UseLegacyVertexColors", Float) = 0
		[Toggle]_UseSpeedTreeWind("UseSpeedTreeWind", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		LOD 200
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "VS_InstancedIndirect.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma instancing_options assumeuniformscaling lodfade maxcount:50 procedural:setup
		#pragma multi_compile GPU_FRUSTUM_ON __
		#pragma exclude_renderers xbox360 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _GradientBrightness;
		uniform float _UseLegacyVertexColors;
		uniform float _AmbientOcclusion;
		uniform float _WindSpeed;
		uniform float _TrunkWindSpeed;
		uniform float4 _WindDirection;
		uniform float _TrunkWindSwinging;
		uniform fixed _TrunkWindWeight;
		uniform float _UseSpeedTreeWind;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 appendResult88 = (float3(_WindDirection.x , 0 , _WindDirection.z));
			float3 _Vector1 = float3(1,1,1);
			float3 appendResult93 = (float3((float3( 0,0,0 ) + (sin( ( ( ( ( _WindSpeed * 0.05 ) * _Time.w ) * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult88 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector1 - float3( 0,0,0 )) / (_Vector1 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))).x , 0 , (float3( 0,0,0 ) + (sin( ( ( ( ( _WindSpeed * 0.05 ) * _Time.w ) * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult88 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector1 - float3( 0,0,0 )) / (_Vector1 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))).z));
			float2 uv2_TexCoord127 = v.texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
			float3 temp_output_41_0 = ( appendResult93 * _TrunkWindWeight * lerp(lerp(v.color.a,v.color.b,_UseLegacyVertexColors),( uv2_TexCoord127.y * 0.01 ),_UseSpeedTreeWind) );
			float3 Wind111 = temp_output_41_0;
			v.vertex.xyz += Wind111;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 Normals113 = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			o.Normal = Normals113;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode45 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult85 = lerp( ( tex2DNode45 * _GradientBrightness ) , tex2DNode45 , ( 1.0 - ( lerp(i.vertexColor.a,i.vertexColor.b,_UseLegacyVertexColors) * 10.0 ) ));
			float4 Albedo115 = lerpResult85;
			o.Albedo = Albedo115.rgb;
			fixed Roughness109 = tex2DNode45.a;
			o.Smoothness = Roughness109;
			float lerpResult120 = lerp( 1 , i.vertexColor.r , _AmbientOcclusion);
			o.Occlusion = lerpResult120;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Nature/SpeedTree"
	CustomEditor "FAE.TreeTrunkShaderGUI"
}
/*ASEBEGIN
Version=15001
1927;29;1906;1004;-1882.842;2139.352;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;119;-473.8982,-2238.46;Float;False;3601.922;1223.073;;29;13;14;16;17;19;15;21;62;18;88;23;82;28;27;83;32;84;81;94;78;37;93;41;111;124;127;128;129;130;Wind motion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-357.037,-2110.237;Float;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-423.8982,-2188.46;Float;False;Global;_WindSpeed;_WindSpeed;7;0;Create;True;0;0;False;0;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-122.4307,-1559.33;Float;False;Global;_TrunkWindSpeed;_TrunkWindSpeed;10;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;15;-122.8037,-2069.158;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-44.63774,-2181.637;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;17;-44.83769,-1464.938;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;18;-98.73761,-1770.237;Float;False;Global;_WindDirection;_WindDirection;9;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;196.2327,-1562.635;Float;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;177.6025,-2132.86;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;174.4365,-1749.536;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;417.268,-1851.53;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;27;587.163,-1464.039;Float;False;Global;_TrunkWindSwinging;_TrunkWindSwinging;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;677.6683,-1766.735;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;82;668.8383,-1648.035;Float;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;83;910.838,-1617.035;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;32;879.9669,-1794.236;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;84;881.838,-1469.036;Float;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;117;782.636,-232.2025;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;81;1284.713,-1768.683;Float;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;78;1484.933,-1431.726;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;127;1481.402,-1248.125;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;1141.989,7.418777;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;125;1032.318,-194.1216;Float;False;Property;_UseLegacyVertexColors;UseLegacyVertexColors;4;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;1909.941,-1215.226;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;94;1549.968,-1735.767;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ToggleSwitchNode;124;1859.178,-1394.346;Float;False;Property;_UseLegacyVertexColors;UseLegacyVertexColors;4;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;710.5229,-583.6145;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;1415.993,-162.0812;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;693.0071,-332.882;Float;False;Property;_GradientBrightness;GradientBrightness;2;0;Create;True;0;0;False;0;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;129;2217.941,-1225.226;Float;False;Property;_UseSpeedTreeWind;UseSpeedTreeWind;5;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;1960.233,-1565.685;Fixed;False;Global;_TrunkWindWeight;_TrunkWindWeight;10;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;2027.235,-1738.305;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;118;1601.959,-193.8573;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;1412.229,-570.617;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;2392.929,-1653.667;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;90;2541.868,-296.6569;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;1702.239,71.77939;Float;True;Property;_BumpMap;BumpMap;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;121;2484.725,-37.76178;Float;False;Property;_AmbientOcclusion;Ambient Occlusion;3;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;85;1792.079,-409.7187;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;2172.658,62.40754;Float;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;2847.944,-283.1704;Float;False;109;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;120;2863.725,-116.7618;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;2845.253,-371.6863;Float;False;113;0;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;2859.665,-459.6248;Float;False;115;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;2849.923,6.235733;Float;False;111;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;2219.219,-416.456;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;1056.77,-466.2452;Fixed;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;130;2620.842,-1638.352;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;2888.024,-1663.535;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3187.507,-301.7967;Float;False;True;2;Float;FAE.TreeTrunkShaderGUI;200;0;Standard;FAE/Tree Trunk;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;False;True;True;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;200;Nature/SpeedTree;-1;-1;-1;-1;1;VS_InstancedIndirect.cginc;0;2;instancing_options assumeuniformscaling lodfade maxcount:50 procedural:setup;multi_compile GPU_FRUSTUM_ON __;False;0;0;0;False;-1;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;13;0
WireConnection;19;1;14;0
WireConnection;62;0;16;0
WireConnection;62;1;17;0
WireConnection;21;0;19;0
WireConnection;21;1;15;4
WireConnection;88;0;18;1
WireConnection;88;2;18;3
WireConnection;23;0;21;0
WireConnection;23;1;62;0
WireConnection;28;0;23;0
WireConnection;28;1;88;0
WireConnection;83;0;82;0
WireConnection;83;1;27;0
WireConnection;32;0;28;0
WireConnection;81;0;32;0
WireConnection;81;1;83;0
WireConnection;81;2;84;0
WireConnection;81;4;84;0
WireConnection;125;0;117;4
WireConnection;125;1;117;3
WireConnection;128;0;127;2
WireConnection;94;0;81;0
WireConnection;124;0;78;4
WireConnection;124;1;78;3
WireConnection;122;0;125;0
WireConnection;122;1;123;0
WireConnection;129;0;124;0
WireConnection;129;1;128;0
WireConnection;93;0;94;0
WireConnection;93;2;94;2
WireConnection;118;0;122;0
WireConnection;86;0;45;0
WireConnection;86;1;87;0
WireConnection;41;0;93;0
WireConnection;41;1;37;0
WireConnection;41;2;129;0
WireConnection;85;0;86;0
WireConnection;85;1;45;0
WireConnection;85;2;118;0
WireConnection;113;0;46;0
WireConnection;120;1;90;1
WireConnection;120;2;121;0
WireConnection;115;0;85;0
WireConnection;109;0;45;4
WireConnection;130;0;41;0
WireConnection;111;0;41;0
WireConnection;0;0;116;0
WireConnection;0;1;114;0
WireConnection;0;4;110;0
WireConnection;0;5;120;0
WireConnection;0;11;112;0
ASEEND*/
//CHKSM=1790A68C0510A6488C19A077D365F1E17D8BECA2