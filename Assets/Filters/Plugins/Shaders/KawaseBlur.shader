Shader "Filters/KawaseBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Iteration("Iteration", Float) = 1
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
			};
			
			float _Iteration;
			float2 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float2 dUV = (_MainTex_TexelSize.xy * float2(_Iteration, _Iteration)) + _MainTex_TexelSize.xy / 2.0f;
				
				o.kernel0.xy = float2(v.uv.x - dUV.x, v.uv.y + dUV.y);
				o.kernel0.zw = float2(v.uv.x + dUV.x, v.uv.y + dUV.y);
				o.kernel1.xy = float2(v.uv.x + dUV.x, v.uv.y - dUV.y);
				o.kernel1.zw = float2(v.uv.x - dUV.x, v.uv.y - dUV.y);	

				return o;
			}
			
			sampler2D _MainTex;

			float4 frag (v2f i) : SV_Target
			{
				float4 col = 0;
				col += tex2D(_MainTex, i.kernel0.xy);
				col += tex2D(_MainTex, i.kernel0.zw);
				col += tex2D(_MainTex, i.kernel1.xy);
				col += tex2D(_MainTex, i.kernel1.zw);				
				return col * 0.25;
			}
			ENDCG
		}
	}
}
