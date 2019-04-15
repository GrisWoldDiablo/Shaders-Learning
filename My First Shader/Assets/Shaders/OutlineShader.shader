Shader "Custom/OutlineShader"
{
	Properties
	{
		_Color("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineColor("Color", Color) = (0,0,0,0)
		_OutlineWidth("Width", Range(0,5)) = 1
	}

	CGINCLUDE
	#include "UnityCG.cginc"
	
	struct appdata 
	{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct v2f 
	{
		float4 pos:POSITION;
		//float4 color : COLOR;
		float3 normal : NORMAL;
	};
	float4 _OutlineColor;
	float _OutlineWidth;

	v2f vert(appdata v)
	{
		v.vertex.xyz *= _OutlineWidth;
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		//o.color = _OutlineColor;
		return o;
	}

	ENDCG

	SubShader
	{
		Tags{"Queue" = "Transparent" }
		// Render the outline
		Pass
		{
			ZWrite Off
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			half4 frag(v2f i) : COLOR
			{
				return _OutlineColor;
			}
			ENDCG
		}

		// Normal render
		Pass
		{
			ZWrite On

			Material
			{
				Diffuse[_Color]
				Ambient[_Color]
			}

			Lighting On

			SetTexture[_MainTex]
			{
				ConstantColor[_Color]
			}

			SetTexture[_MainTex]
			{
				Combine previous * primary DOUBLE
			}

		}
	
	}//End SubShader
}//End Shader
