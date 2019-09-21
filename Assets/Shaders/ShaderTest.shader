Shader "Unlit/ShaderTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 clippos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float4 CustomComputeScreenPos(float4 pos)
			{
                float4 o = pos * 0.5f;
				o.xy = float2(o.x, o.y*_ProjectionParams.x) + o.w;
				o.zw = pos.zw;
    
				return o;
			}

            v2f vert (appdata v)
            {
                v2f o;
				o.clippos = UnityObjectToClipPos(v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
				//return col;


{
                // vertex : SV_POSITION; 是屏幕空间中的像素坐标 
                // [0, screenwidth]  [0, screenheight]
        
				//return fixed4(i.vertex.x / 1000.0, i.vertex.y / 600.0, 0 , 1.0f);	// i.vertex: sspixelpos
}				




                // clippos 是mvp后的值，需要手动ndc后 == SV_POSITION
                // [-w, w]
{

				float4 screenpos = ComputeScreenPos(i.clippos);
				return fixed4(screenpos.x / screenpos.w, screenpos.y / screenpos.w, 0, 1.0f);


                float4 ret;
                ret = i.clippos / i.clippos.w;
                ret = ret * 0.5f + 0.5f;
               // return fixed4(ret.x, 0, 0, 1.0f);
}


            }
            ENDCG
        }
    }
}
