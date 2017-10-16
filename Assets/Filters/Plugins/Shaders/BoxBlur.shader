Shader "Filters/BoxBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Radius("Radius", Float) = 0.1
		_Direction("Direction", Vector) = (1, 0, 0, 0)
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
				float4 kernel3 : TEXCOORD3;
				float4 kernel4 : TEXCOORD4;
			};
			
			float _Radius;
			float2 _Direction;
			float2 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float r = _Radius * _MainTex_TexelSize;

				o.kernel0.xy = float2(v.uv.x - _Direction.x * r * 4, v.uv.y - _Direction.y * r * 4);
				o.kernel0.zw = float2(v.uv.x - _Direction.x * r * 3, v.uv.y - _Direction.y * r * 3);
				o.kernel1.xy = float2(v.uv.x - _Direction.x * r * 2, v.uv.y - _Direction.y * r * 2);
				o.kernel1.zw = float2(v.uv.x - _Direction.x * r * 1, v.uv.y - _Direction.y * r * 1);
				o.kernel2 = v.uv;
				o.kernel3.xy = float2(v.uv.x + _Direction.x * r * 1, v.uv.y + _Direction.y * r * 1);
				o.kernel3.zw = float2(v.uv.x + _Direction.x * r * 2, v.uv.y + _Direction.y * r * 2);
				o.kernel4.xy = float2(v.uv.x + _Direction.x * r * 3, v.uv.y + _Direction.y * r * 3);
				o.kernel4.zw = float2(v.uv.x + _Direction.x * r * 4, v.uv.y + _Direction.y * r * 4);
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
				col += tex2D(_MainTex, i.kernel2.xy);
				col += tex2D(_MainTex, i.kernel3.xy);
				col += tex2D(_MainTex, i.kernel3.zw);
				col += tex2D(_MainTex, i.kernel4.xy);
				col += tex2D(_MainTex, i.kernel4.zw);
				return col * 0.1111111111;
			}
			ENDCG
		}
	}
}
