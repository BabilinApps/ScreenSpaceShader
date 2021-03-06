﻿Shader "Unlit/ScreenSpace"
{
	Properties
	{
		_MyFloat("Alpha", Float) = 0.5
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
	}
		Category
	{
		Cull back
		Blend SrcAlpha OneMinusSrcAlpha
		Tags{ Queue = Transparent }
	SubShader
	{
		
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 screenPos : TEXCOORD0;

				UNITY_FOG_COORDS(1)

			};

			sampler2D _MainTex;
			float _MyFloat;

			v2f vert(appdata v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.screenPos = o.vertex.xyw;

				// Correct flip when rendering with a flipped projection matrix.
				// (I've observed this differing between the Unity scene & game views)
				o.screenPos.y *= _ProjectionParams.x;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
		{
				float2 screenUV = (i.screenPos.xy / i.screenPos.z) * 0.5f + 0.5f;
				// sample the texture
				fixed4 col = tex2D(_MainTex, screenUV);
				col.a = _MyFloat;
	//			UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
	}
}
