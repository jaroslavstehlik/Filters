Shader "Filters/Sharpen"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
				float2 kernel2 : TEXCOORD2;
			};
			
			float _Radius;
			float2 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float r = _Radius * _MainTex_TexelSize;

				o.kernel0.xy = float2(v.uv.x - r, v.uv.y);
				o.kernel0.zw = float2(v.uv.x + r, v.uv.y);
				o.kernel1.xy = float2(v.uv.x, v.uv.y - r);
				o.kernel1.zw = float2(v.uv.x, v.uv.y + r);
				o.kernel2 = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			float4 frag (v2f i) : SV_Target
			{
				float4 col = 0;
				col += tex2D(_MainTex, i.kernel0.xy) * -1;
				col += tex2D(_MainTex, i.kernel0.zw) * -1;
				col += tex2D(_MainTex, i.kernel2) * 5;
				col += tex2D(_MainTex, i.kernel1.xy) * -1;
				col += tex2D(_MainTex, i.kernel1.zw) * -1;
				return col;
			}
			ENDCG
		}
	}
}
