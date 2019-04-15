// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/SpotlightShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CharPos("Character Position", vector) = (0,0,0,0)
		_CircleRad("Spotlight size", Range(0,20)) = 3
		_RingSize("Ring size", Range(0,5)) = 1
		_ColorTint("Outside of the spotlight color", color) = (0,0,0,0)
		_Deformation("Deformation", Range(-5,5)) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Cull Off
			Lighting on
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

				//float3 worldPos : TEXCOORD1; // World position of the vertex
				float dist: TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _CharPos;
			float _CircleRad;
			float _RingSize;
			float4 _ColorTint;
			float _Deformation;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				//o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.dist = distance(worldPos, _CharPos.xyz);
				if (o.dist > _CircleRad && o.dist < _CircleRad + _RingSize)
				{
					o.vertex.y += (o.dist - _Deformation) * _Deformation * sin(_Time.w);
				}


				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = _ColorTint;
			
				//float dist = distance(i.worldPos, _CharPos.xyz);

				// This is the player's Spotlight
				if (i.dist< _CircleRad)
				{
					col = tex2D(_MainTex, i.uv);
				}
				// This is the blending section
				else if (i.dist >  _CircleRad && i.dist < _CircleRad + _RingSize)
				{
					float blendStrength = i.dist - _CircleRad;
					col = lerp(tex2D(_MainTex, i.uv), _ColorTint, blendStrength / _RingSize);
				}
				// This past both the players Spotlight and the blending section

				return col;
			}
			
			ENDCG
		}
		Pass
		{
			 CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _MainTex;

			struct Input
			{
				float2 uv_MainTex;
			};

			half _Glossiness;
			half _Metallic;
			fixed4 _Color;

			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf (Input IN, inout SurfaceOutputStandard o)
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
			}
			ENDCG
		}
	}
}
