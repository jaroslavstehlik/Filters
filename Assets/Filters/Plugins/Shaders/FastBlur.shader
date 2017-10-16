Shader "Filters/FastBlur"
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
			};
			
			float _Radius;
			float2 _Direction;
			float2 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);				
				float r = _Radius * _MainTex_TexelSize;
				o.kernel0.xy = float2(v.uv.x - _Direction.x * r, v.uv.y - _Direction.y * r);
				o.kernel0.zw = float2(v.uv.x + _Direction.x * r, v.uv.y + _Direction.y * r);
				return o;
			}
			
			sampler2D _MainTex;

			float4 frag (v2f i) : SV_Target
			{
				float4 col = 0;
				col += tex2D(_MainTex, i.kernel0.xy);
				col += tex2D(_MainTex, i.kernel0.zw);
				return col * 0.5;
			}
			ENDCG
		}
	}
}
