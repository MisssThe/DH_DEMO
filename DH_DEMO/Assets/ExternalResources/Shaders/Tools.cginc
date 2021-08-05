#ifndef TOOLS
#define TOOLS
//----------------------------------------常用变量----------------------------------------
#include "Lighting.cginc"
#include "UnityCG.cginc"
//----------------------------------------常用变量----------------------------------------
sampler2D _MainTex;     
float4 _MainTex_ST;
float2 _MainTex_TexelSize;
sampler2D _DownSampleTex;
float4 _DownSampleTex_ST;
float2 _DownSampleTex_PixelSize;
sampler2D _CameraDepthTexture;
half _RadialBlurAmount;
half _GaussianBlurAmount;
half _BloomThreshold;

//----------------------------------------预定义宏----------------------------------------
#define CENTER_COORD fixed2(0.5,0.5)            
#define BASE_OFFSET _MainTex_TexelSize
#define GAUSSIAN_KERNEL fixed3(0.0947416,0.118318,0.147761)
#define PI 3.1415926
#define RADIAN_ANGLE 180 / PI 
#define Angle_RADIAN PI / 180
#define TIME _Time.y

//----------------------------------------顶点偏移----------------------------------------
//sin函数
struct SinValue
{
    float A;
    float B;
    float C;
};
inline float3 sin3(float3 x)
{
    float3 temp;
    temp = float3(sin(x.x),sin(x.y),sin(x.z));
    return temp;
}
//保证方向为正数（有点玩具，可以不用）
inline float3 offsetBySin(float3 vertex,float3 offset_dir,SinValue sv)
{
    float3 out_vertex = (fixed3(1,1,1) - offset_dir) * sv.A * sin3(vertex * sv.B + sv.C) + offset_dir;
    out_vertex = offset_dir * (out_vertex.x * out_vertex.y * out_vertex.z);
    return out_vertex;
}


//----------------------------------------模糊效果----------------------------------------
//高斯模糊
/*
    颜色叠加
*/
inline half3 ColorOverlay(fixed3 color1,fixed3 color2)
{
    return (color1 + color2) / 2;
}
inline half3 ColorOverlay(fixed3 color1,fixed2 uv)
{
    return (color1 + tex2D(_MainTex,uv)) / 2;
}
inline half3 ColorOverlay(fixed2 uv1,fixed2 uv2)
{
    return (tex2D(_MainTex,uv1) + tex2D(_MainTex,uv2)) / 2;
}

/*
    高斯模糊
*/
inline fixed3 GaussianBlur(fixed2 uv)
{
    fixed3 color = 0;
    fixed2 offset = BASE_OFFSET * _GaussianBlurAmount;
    //left   top
    color += GAUSSIAN_KERNEL[0] * tex2D(_MainTex,uv + fixed2(-1,-1) * offset);
    //mid    top
    color += GAUSSIAN_KERNEL[1] * tex2D(_MainTex,uv + fixed2( 0,-1) * offset);
    //right  top
    color += GAUSSIAN_KERNEL[0] * tex2D(_MainTex,uv + fixed2( 1,-1) * offset);
    //left   mid
    color += GAUSSIAN_KERNEL[1] * tex2D(_MainTex,uv + fixed2(-1, 0) * offset);
    //mid    mid
    color += GAUSSIAN_KERNEL[2] * tex2D(_MainTex,uv + fixed2( 0, 0) * offset);
    //right  mid
    color += GAUSSIAN_KERNEL[1] * tex2D(_MainTex,uv + fixed2( 1, 0) * offset);
    //left   bottom
    color += GAUSSIAN_KERNEL[0] * tex2D(_MainTex,uv + fixed2(-1, 1) * offset);
    //mid    bottom
    color += GAUSSIAN_KERNEL[1] * tex2D(_MainTex,uv + fixed2( 0, 1) * offset);
    //right  bottom
    color += GAUSSIAN_KERNEL[0] * tex2D(_MainTex,uv + fixed2( 1, 1) * offset);
    color = color / 6;
}

/*
    径向模糊
    离中心越远采样距离越大，采样次数越多
    可以采样分辨率较低的RT图以提升效率
*/
inline half3 RadialBlur(int sample_count,fixed2 coord)
{
    half3 color = 0;
    fixed2 dir = CENTER_COORD - coord;
    for (int i = 0; i < sample_count; i++)
    {
        //计算采样uv值：正常uv值+从中间向边缘逐渐增加的采样距离
        coord = coord + dir * i * _RadialBlurAmount;
        color += tex2D(_MainTex, coord);
    }
    return color / sample_count;
}

/*
    运动模糊
*/
inline fixed3 MotionBlur()
{
    return fixed3(1,1,1);
}


//----------------------------------------特殊效果----------------------------------------
/*
    Bloom效果
*/
inline fixed GetLuminance(fixed3 color)
{
    return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b; 
}
inline fixed3 Bloom(fixed2 uv)
{
    fixed3 color = tex2D(_MainTex,uv);
    fixed luminance = GetLuminance(color);
    fixed factor = clamp(luminance - _BloomThreshold,0.0f,1.0f);
    return factor * color;
}
//----------------------------------------边缘检测----------------------------------------

//----------------------------------------传统光照----------------------------------------
/*
    Lambert光照模型
*/
inline fixed3 Lambert(fixed3 ambientColor,fixed3 lightColor,fixed3 albedo,fixed3 lightDir,fixed3 normalDir)
{
    fixed3 ambient = ambientColor;
    fixed3 diffuse = lightColor * albedo * saturate(dot(lightDir,normalDir));
    return ambient + diffuse;
}
/*
    Bliin_Phong光照模型
*/
inline fixed3 Bliin_Phong(fixed3 ambientColor,fixed3 lightColor,fixed3 albedo,fixed3 specularColor,fixed3 lightDir,fixed3 normalDir,half gloss)
{
    fixed3 ambient_diffuse = Lambert(ambientColor,lightColor,albedo,lightDir,normalDir);
    fixed3 specular = lightColor * specularColor * pow(dot(lightDir,normalDir),gloss);
    return ambient_diffuse + specular;
}
//----------------------------------------物理光照----------------------------------------
/*
    菲尼尔效应
*/
inline fixed3 Fresnel(fixed3 F0,fixed nv)
{
    fixed3 fre = F0 + (fixed3(1,1,1) - F0) * pow(1 - nv ,5);
    return fre;
}
//金属流
//镜面流
#endif