Shader "Custom/AlwaysVisOutlineShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Always visisble Color", Color) = (0,0,0,0)
		_OutlineColor("Color", Color) = (0,0,0,0)
		_OutlineWidth("Width", Range(-5,5)) = 1
	}
	SubShader
	{
		Tags { "Queue"="Transparent+1" }
		LOD 100

		Pass
		{
			//ZWrite On
			ZTest Greater
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : POSITION;
				float3 normal : NORMAL;
			};

			float4 _OutlineColor;
			float _OutlineWidth;

			v2f vert(appdata v)
			{
				v.vertex.xyz *= _OutlineWidth;
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			half4 frag(v2f i) : COLOR
			{
				return _OutlineColor;
			}

			ENDCG
		}
		
		Pass
		{

			//Cull Off
			ZWrite Off // Controls whether pixels from this object are written to the depth buffer (default is On).
					   // if you are drawing solid objects, leave this on, if you are drawing semitransparent effects, switch to ZWrite Off
			ZTest Always



			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float4 _Color;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return _Color;
			}

			ENDCG
		}
		
		

		Pass
		{
			
			//ZWrite On
			//ZTest Always
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

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				return col;
			}
			ENDCG
		}

	}
}
