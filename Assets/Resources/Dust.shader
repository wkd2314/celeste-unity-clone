Shader "Hidden/Dust"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        struct Attributes 
        {
            float4 positionOS	: POSITION;
            float3 normalOS : NORMAL;
            // UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        struct Varyings 
        {
            float4 positionCS 	: SV_POSITION;
            uint id : SV_InstanceID;
            // UNITY_VERTEX_INPUT_INSTANCE_ID
            // UNITY_VERTEX_OUTPUT_STEREO
        };

        float nrand(float2 uv)
        {
	        return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
        }


        StructuredBuffer<float3> _InstancesBuffer;

        Varyings vert (Attributes input, uint id : SV_InstanceID)
        {
            Varyings output;
            const float3 offset = float3(_InstancesBuffer[id].xy, 0);

            VertexPositionInputs positionInputs = GetVertexPositionInputs(input.positionOS.xyz + offset);

            output.positionCS = TransformWorldToHClip(positionInputs.positionWS);
            output.id = id;
            
            return output;
        }
        
        float4 frag (Varyings input) : SV_Target
        {
            // UNITY_SETUP_INSTANCE_ID(input);
            // UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
            
            float ranVal = nrand(_InstancesBuffer[input.id].xy);
            float4 finColor = 0.8 + ranVal * 0.2;
            finColor.a = _InstancesBuffer[input.id].z;
            clip(finColor);
            
            return finColor;
        }
        ENDHLSL

        Pass
        {
            Tags{"LightMode"="SRPDefaultUnlit"}
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            
            ENDHLSL
        }
//
//        Pass
//        {
//            Tags{"LightMode"="ShadowCaster"}
//            ZWrite On
//            ZTest LEqual
//            ColorMask 0
//            
//            HLSLPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            
//            #pragma  multi_compile_shadowcaster
//            
//            ENDHLSL
//        }
//
//        Pass
//        {
//            Tags 
//            {
//                "LightMode"="DepthOnly"
//            }
//            
//            HLSLPROGRAM
//
//            #pragma vertex vert
//            #pragma fragment frag
//
//            ENDHLSL
//        }
//         
//        Pass
//        {
//            Tags 
//            {
//                "LightMode"="DepthNormalsOnly"
//            }
//            HLSLPROGRAM
//
//            #pragma vertex vert
//            #pragma fragment frag
//
//            ENDHLSL
//        }
    }
}
