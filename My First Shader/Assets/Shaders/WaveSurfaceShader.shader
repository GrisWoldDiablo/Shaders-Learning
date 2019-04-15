Shader "Custom/WaveSurfaceShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_Deformation("Deformation Value", Range(-1,1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Cull Off
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard vertex:vert addshadow
		//#pragma surface surf Standard fullforwardshadows
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NoiseTex;

		struct Input
		{
			float2 uv_MainTex;
			float4 vertex : SV_POSITION;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			float4 vertex : SV_POSITION;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Deformation;
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void vert (inout appdata_full v) 
		{
			v2f i;
			i.vertex = v.vertex;
			//i.vertex = UnityObjectToViewPos (v.vertex);

			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			float4 offset = float4( 
					tex2Dlod( _NoiseTex, float4(v.vertex.z ,v.vertex.x ,v.vertex.y,0) ).rgb,
					 
					0 );
			
			i.vertex.y += sin(offset.x * worldPos.x + _Time[1]) * _Deformation;
			i.vertex.y += sin(offset.z * worldPos.z + _Time[1]) * _Deformation;
			
			v.vertex = i.vertex;
		}

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

	FallBack "Diffuse"
}
