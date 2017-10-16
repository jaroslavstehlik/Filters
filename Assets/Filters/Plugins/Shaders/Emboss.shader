Shader "Filters/Emboss"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Radius ("Radius", Float) = 0.1
		_Midpoint ("Midpoint", Float) = 0.5
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
#if HORIZONTAL
				float4 uv0 : TEXCOORD0;
#endif
#if VERTICAL
				float4 uv1 : TEXCOORD1;
#endif
			};

			float _Radius;
			float2 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);				
#if HORIZONTAL
				o.uv0.xy = v.uv;
				o.uv0.zw = v.uv;
				o.uv0.x += _Radius * _MainTex_TexelSize.x;
				o.uv0.z -= _Radius * _MainTex_TexelSize.x;
#endif
#if VERTICAL
				o.uv1.xy = v.uv;
				o.uv1.zw = v.uv;
				o.uv1.y += _Radius * _MainTex_TexelSize.y;
				o.uv1.w -= _Radius * _MainTex_TexelSize.y;
#endif
				
				return o;
			}
			
			sampler2D _MainTex;
			fixed _Midpoint;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = _Midpoint;
#if HORIZONTAL
				col -= tex2D(_MainTex, i.uv0.xy);
				col += tex2D(_MainTex, i.uv0.zw);
#endif

#if VERTICAL
				col -= tex2D(_MainTex, i.uv1.xy);
				col += tex2D(_MainTex, i.uv1.zw);
#endif

#if GRAYSCALE
				col = (col.r + col.g + col.b) * 0.3333333333;
#endif
				return col;
			}
			ENDCG
		}
	}

	CustomEditor "FiltersEmbossEditor"
}
