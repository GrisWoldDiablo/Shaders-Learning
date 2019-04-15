Shader "Custom/Test"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondaryTex("This is a second texture", 2D) = "white" {}
		_ColorTint("Tint", Color) = (1, 1, 1, 1)
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_ChararterPosition("Charater's Position", Vector) = (0, 0, 0, 0)
		_MyFloat("Float", Float) = 10
		_MyRange("Range", Range(0,100)) = 10

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 worldPosition : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;
			float _MyRange;
			float _MyFloat;
			float4 _ColorTint;

			// vertex is for all vertex on the object
			// This is going to be call for each vertex
			v2f vert (appdata v)
			{
				v2f o;
				float4 offset = float4(
					tex2Dlod(_NoiseTex, float4(v.vertex.x / 10 + _Time[1] / _MyRange, v.vertex.y / 10 + _Time[1] / _MyRange, 0, 0)).rgb,
					0);
				o.worldPosition = v.vertex  + offset * _MyFloat;
				o.vertex = UnityObjectToClipPos(o.worldPosition);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			// Pixel shader
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
