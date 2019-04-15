Shader "Hidden/PostEffectShader"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f IN) : SV_Target // ran on every pixels
			{
				// If we are running 1920x1080.. that is over 2 million pixels??
				// How fast or slow does this end up being? REALLY FAST!

				// float a = 2.18;
				// float b = 3.17;
				// float c = a * b;
				// float d = pow(a, c);


				fixed4 col = tex2D(_MainTex, IN.uv - float2(0, sin(IN.vertex.x/50 + _Time[1]/2) / 100));
				// just invert the colors
				//col.rgb = 1 - col.rgb;
				
				

				return col;
			}
			ENDCG
		}
	}
}
