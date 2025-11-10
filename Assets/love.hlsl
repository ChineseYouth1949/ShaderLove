/*
void mainImage( out vec4 fragColor, in float2 fragCoord )
{
    float2 p = (2.0*fragCoord-iResolution.xy)/min(iResolution.y,iResolution.x);
        
    // background color
    vec3 bcol = vec3(1.0,0.8,0.7-0.07*p.y)*(1.0-0.25*length(p));

    // animate
    float tt = mod(iTime,1.5)/1.5;
    float ss = pow(tt,.2)*0.5 + 0.5;
    ss = 1.0 + ss*0.5*sin(tt*6.2831*3.0 + p.y*0.5)*exp(-tt*4.0);
    p *= float2(0.5,1.5) + ss*float2(0.5,-0.5);

    // shape
        p.y -= 0.25;
    float a = atan(p.x,p.y)/3.141593;
    float r = length(p);
    float h = abs(a);
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);
    
        // color
        float s = 0.75 + 0.75*p.x;
        s *= 1.0-0.4*r;
        s = 0.3 + 0.7*s;
        s *= 0.5+0.5*pow( 1.0-clamp(r/d, 0.0, 1.0 ), 0.1 );
        vec3 hcol = vec3(1.0,0.4*r,0.3)*s;
        
    vec3 col = mix( bcol, hcol, smoothstep( -0.01, 0.01, d-r) );

    fragColor = vec4(col,1.0);
}
*/

cbuffer ConstantBuffer : register(b0)
{
    float2 cResolution;
    float cTime;
    float cScale;
    int cTimeBackColor;
    int cTimeLoveColor;
};

struct VSOutput
{
    float4 position : SV_POSITION;
};

VSOutput VSMain(float3 position : POSITION)
{
    VSOutput res;
    res.position = float4(position.x, position.y, position.z, 1.0);
    return res;
}

float4 PSMain(VSOutput input) : SV_TARGET
{
    // ----transform----
    float2 iResolution = cResolution;
    float iTime = cTime;
    
    float2 fragCoord = float2(input.position.x, cResolution.y - input.position.y);
    float2 uv = fragCoord / iResolution.xy;
    
    float4 fragColor = float4(1.0, 0.0, 0.0, 1.0);
    
    // scale from screen center]
    float2 center = iResolution * 0.5;
    fragCoord = (fragCoord - center) * cScale + center;
    
    // ----your code----
    float2 p = (2.0 * fragCoord - iResolution.xy) / min(iResolution.y, iResolution.x);
        
    // background color
    float3 bcol = float3(1.0, 0.8, 0.7 - 0.07 * p.y) * (1.0 - 0.25 * length(p));

    // animate
    float tt = fmod(iTime, 1.5) / 1.5;
    float ss = pow(tt, .2) * 0.5 + 0.5;
    ss = 1.0 + ss * 0.5 * sin(tt * 6.2831 * 3.0 + p.y * 0.5) * exp(-tt * 4.0);
    p *= float2(0.5, 1.5) + ss * float2(0.5, -0.5);

    // shape
    p.y -= 0.25;
    float a = atan2(p.x, p.y) / 3.141593;
    float r = length(p);
    float h = abs(a);
    float d = (13.0 * h - 22.0 * h * h + 10.0 * h * h * h) / (6.0 - 5.0 * h);
    
    // color
    float s = 0.75 + 0.75 * p.x;
    s *= 1.0 - 0.4 * r;
    s = 0.3 + 0.7 * s;
    s *= 0.5 + 0.5 * pow(1.0 - clamp(r / d, 0.0, 1.0), 0.1);
    float3 hcol = float3(1.0, 0.4 * r, 0.3) * s;
        
    float3 col = lerp(bcol, hcol, smoothstep(-0.01, 0.01, d - r));

    float3 backColor = 0.5 * cos(iTime + uv.xyx + float3(0, 2, 4)) * cTimeBackColor;
    fragColor = float4(col, 1.0) + float4(backColor, 1.0) * cTimeBackColor;

    return fragColor;
}