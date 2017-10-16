Shader "Filters/Outline"
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
			#pragma shader_feature GRAYSCALE
			#pragma shader_feature HIGH

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
				float4 kernel3 : TEXCOORD3;
				float2 uv : TEXCOORD4;
			};

			float _Radius;
			float2 _MainTex_TexelSize;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float r = _Radius * _MainTex_TexelSize;
				o.uv = v.uv;
				o.kernel0.xy = float2(v.uv.x - r, v.uv.y + r);
				o.kernel0.zw = float2(v.uv.x, v.uv.y + r);
				o.kernel1.xy = float2(v.uv.x + r, v.uv.y + r);
				o.kernel1.zw = float2(v.uv.x - r, v.uv.y);
				o.kernel2.xy = float2(v.uv.x + r, v.uv.y);
				o.kernel2.zw = float2(v.uv.x - r, v.uv.y - r);
				o.kernel3.xy = float2(v.uv.x, v.uv.y - r);
				o.kernel3.zw = float2(v.uv.x - r, v.uv.y - r);
				return o;
			}

			sampler2D _MainTex;

			float4 frag(v2f i) : SV_Target
			{
#if HIGH
				float4 col = tex2D(_MainTex, i.uv) * 8;
				col -= tex2D(_MainTex, i.kernel0.xy);
				col -= tex2D(_MainTex, i.kernel0.zw);
				col -= tex2D(_MainTex, i.kernel1.xy);
				col -= tex2D(_MainTex, i.kernel1.zw);
				col -= tex2D(_MainTex, i.kernel2.xy);
				col -= tex2D(_MainTex, i.kernel2.zw);
				col -= tex2D(_MainTex, i.kernel3.xy);
				col -= tex2D(_MainTex, i.kernel3.zw);
#else
				float4 col = tex2D(_MainTex, i.uv) * 4;
				col -= tex2D(_MainTex, i.kernel0.zw);
				col -= tex2D(_MainTex, i.kernel1.zw);
				col -= tex2D(_MainTex, i.kernel2.xy);
				col -= tex2D(_MainTex, i.kernel3.xy);
#endif

#if GRAYSCALE
				col = (col.r + col.g + col.b) * 0.3333333333;
#endif
				return col;
			}
			ENDCG
		}
	}

	CustomEditor "FiltersOutlineEditor"
}
