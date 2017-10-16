Shader "Filters/Sobel"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Radius("Radius", Float) = 0.1
	}
		
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature HORIZONTAL
			#pragma shader_feature VERTICAL
			#pragma shader_feature GRAYSCALE

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 kernel0 : TEXCOORD0;
				float4 kernel1 : TEXCOORD1;
				float4 kernel2 : TEXCOORD2;				
			};

			float _Radius;
			float2 _MainTex_TexelSize;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float r = _Radius * _MainTex_TexelSize;
#if VERTICAL
				o.kernel0.xy = float2(v.uv.x - r, v.uv.y + r);
				o.kernel0.zw = float2(v.uv.x, v.uv.y + r);
				o.kernel1.xy = float2(v.uv.x + r, v.uv.y + r);
				o.kernel1.zw = float2(v.uv.x - r, v.uv.y - r);
				o.kernel2.xy = float2(v.uv.x, v.uv.y - r);
				o.kernel2.zw = float2(v.uv.x + r, v.uv.y - r);
#endif
#if HORIZONTAL
				o.kernel0.xy = float2(v.uv.x + r, v.uv.y + r);
				o.kernel0.zw = float2(v.uv.x + r, v.uv.y);
				o.kernel1.xy = float2(v.uv.x + r, v.uv.y + r);
				o.kernel1.zw = float2(v.uv.x - r, v.uv.y + r);
				o.kernel2.xy = float2(v.uv.x - r, v.uv.y);
				o.kernel2.zw = float2(v.uv.x - r, v.uv.y - r);
#endif
				return o;
			}

			sampler2D _MainTex;

			float4 frag(v2f i) : SV_Target
			{
				float4 col = 0;
				col += tex2D(_MainTex, i.kernel0.xy);
				col += tex2D(_MainTex, i.kernel0.zw) * 2;
				col += tex2D(_MainTex, i.kernel1.xy);
				col += tex2D(_MainTex, i.kernel1.zw) * -1;
				col += tex2D(_MainTex, i.kernel2.xy) * -2;
				col += tex2D(_MainTex, i.kernel2.zw) * -1;

#if GRAYSCALE
				col = (col.r + col.g + col.b) * 0.3333333333;
#endif
				return col;
			}
			ENDCG
		}
	}

	CustomEditor "FiltersSobelEditor"
}
