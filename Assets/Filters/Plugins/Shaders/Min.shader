// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Filters/Min"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Radius("Radius", Float) = 1.0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// Horizontal Pass
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature GRAYSCALE

			#include "UnityCG.cginc"
			float _Radius;

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
				float4 kernel3 : TEXCOORD3;
			};

			float4 _MainTex_TexelSize;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.kernel0.xy = v.uv.xy + float2(_MainTex_TexelSize.x * _Radius, 0);
				o.kernel0.zw = v.uv.xy - float2(_MainTex_TexelSize.x * _Radius, 0);
				o.kernel1.xy = v.uv.xy + float2(0, _MainTex_TexelSize.y * _Radius);
				o.kernel1.zw = v.uv.xy - float2(0, _MainTex_TexelSize.y * _Radius);
				o.kernel2.xy = v.uv.xy + float2(_MainTex_TexelSize.x * _Radius, _MainTex_TexelSize.y * _Radius);
				o.kernel2.zw = v.uv.xy - float2(_MainTex_TexelSize.x * _Radius, _MainTex_TexelSize.y * _Radius);
				o.kernel3.xy = v.uv.xy + float2(-_MainTex_TexelSize.x * _Radius, _MainTex_TexelSize.y * _Radius);
				o.kernel3.zw = v.uv.xy - float2(-_MainTex_TexelSize.x * _Radius, _MainTex_TexelSize.y * _Radius);
				return o;
			}

			sampler2D _MainTex;

			float4 frag(v2f i) : SV_Target
			{
				float4 col = 0.0;
				
				// Horizontal
				col.rgb += min(tex2D(_MainTex, i.kernel0.xy), tex2D(_MainTex, i.kernel0.zw));
				// Vertical
				col.rgb += min(tex2D(_MainTex, i.kernel1.xy), tex2D(_MainTex, i.kernel1.zw));
				// Diagonal
				col.rgb += min(tex2D(_MainTex, i.kernel2.xy), tex2D(_MainTex, i.kernel2.zw));
				col.rgb += min(tex2D(_MainTex, i.kernel3.xy), tex2D(_MainTex, i.kernel3.zw));

				col.rgb *= 0.25;
#if GRAYSCALE
				col = (col.r + col.g + col.b) * 0.3333333333;
#endif
				return col;
			}
			ENDCG
		}
	}

	CustomEditor "FiltersGrayscaleEditor"
}
