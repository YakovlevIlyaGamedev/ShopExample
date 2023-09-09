Shader "Custom/StandartNoiseChangeColor"
{
    Properties
    {
        _Edge("Edge", Range(-0.2, 2)) = 0.41
        _BaseColor("BaseColor", Color) = (1, 0, 0, 0)
        _ReplaceableColor("ReplaceableColor", Color) = (0, 1, 0.9894493, 0)
        _NoiseScale("NoiseScale", Range(0, 5)) = 0.78
        _NormalizeCoefficient("NormalizeCoefficient", Float) = 1.41
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _Metallic("Metallic", Range(0, 1)) = 0
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 0
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue" = "Geometry"
            "ShaderGraphShader" = "true"
            "ShaderGraphTargetId" = "UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

        // Render State
        Cull[_Cull]
        Blend[_SrcBlend][_DstBlend]
        ZTest[_ZTest]
        ZWrite[_ZWrite]

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        // GraphKeywords: <None>

        // Defines

        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 ObjectSpacePosition;
             float3 AbsoluteWorldSpacePosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float3 interp3 : INTERP3;
             float2 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float3 interp6 : INTERP6;
             float4 interp7 : INTERP7;
             float4 interp8 : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

        PackedVaryings PackVaryings(Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz = input.positionWS;
            output.interp1.xyz = input.normalWS;
            output.interp2.xyzw = input.tangentWS;
            output.interp3.xyz = input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp4.xy = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp5.xy = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz = input.sh;
            #endif
            output.interp7.xyzw = input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp8.xyzw = input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

        Varyings UnpackVaryings(PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.viewDirectionWS = input.interp3.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp4.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp8.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }


        // --------------------------------------------------
        // Graph

        // Graph Properties
        //CBUFFER_START(UnityPerMaterial)
        half4 _BaseColor;
        half4 _ReplaceableColor;
        half _NoiseScale;
        half _Smoothness;
        half _Metallic;

        UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(half, _Edge)
            UNITY_DEFINE_INSTANCED_PROP(half, _NormalizeCoefficient)
        UNITY_INSTANCING_BUFFER_END(Props)
        //CBUFFER_END

            // Object and Global properties

            // Graph Includes
            // GraphIncludes: <None>

            // -- Property used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif

        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif

        // Graph Functions

        void Unity_Distance_float2(float2 A, float2 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }

        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

        // Graph Vertex
        struct VertexDescription
        {
            half3 Position;
            half3 Normal;
            half3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif

        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            half3 NormalTS;
            half3 Emission;
            half Metallic;
            half3 Specular;
            half Smoothness;
            half Occlusion;
            half Alpha;
            half AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            half4 _Property_ffa90d3b3f77485e984796da11d0ac19_Out_0 = _BaseColor;
            half _Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0 = UNITY_ACCESS_INSTANCED_PROP(Props, _Edge);
            float _Split_781cad85a9f046a8980ed2a1d2d10664_R_1 = IN.ObjectSpacePosition[0];
            float _Split_781cad85a9f046a8980ed2a1d2d10664_G_2 = IN.ObjectSpacePosition[1];
            float _Split_781cad85a9f046a8980ed2a1d2d10664_B_3 = IN.ObjectSpacePosition[2];
            float _Split_781cad85a9f046a8980ed2a1d2d10664_A_4 = 0;
            float2 _Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0 = float2(_Split_781cad85a9f046a8980ed2a1d2d10664_R_1, _Split_781cad85a9f046a8980ed2a1d2d10664_B_3);
            float _Distance_767d57b101584aec91e1737df8c8189a_Out_2;
            Unity_Distance_float2(_Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0, float2(0, 0), _Distance_767d57b101584aec91e1737df8c8189a_Out_2);
            half _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0 = UNITY_ACCESS_INSTANCED_PROP(Props, _NormalizeCoefficient);
            float _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2;
            Unity_Divide_float(_Distance_767d57b101584aec91e1737df8c8189a_Out_2, _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0, _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2);
            float _Split_0adf1cac2e75421a859d31b60cd64966_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_0adf1cac2e75421a859d31b60cd64966_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_0adf1cac2e75421a859d31b60cd64966_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_0adf1cac2e75421a859d31b60cd64966_A_4 = 0;
            float2 _Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0 = float2(_Split_0adf1cac2e75421a859d31b60cd64966_R_1, _Split_0adf1cac2e75421a859d31b60cd64966_B_3);
            half _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0 = _NoiseScale;
            float _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2;
            Unity_GradientNoise_float(_Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0, _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2);
            float _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2;
            Unity_Add_float(_Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2);
            float _Step_737f617fc2ec402a993374a78d94cdff_Out_2;
            Unity_Step_float(_Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2, _Step_737f617fc2ec402a993374a78d94cdff_Out_2);
            float4 _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2;
            Unity_Multiply_float4_float4(_Property_ffa90d3b3f77485e984796da11d0ac19_Out_0, (_Step_737f617fc2ec402a993374a78d94cdff_Out_2.xxxx), _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2);
            float _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1;
            Unity_OneMinus_float(_Step_737f617fc2ec402a993374a78d94cdff_Out_2, _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1);
            half4 _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0 = _ReplaceableColor;
            float4 _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2;
            Unity_Multiply_float4_float4((_OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1.xxxx), _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2);
            float4 _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2;
            Unity_Add_float4(_Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2, _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2);
            half _Property_4c3a908b10dc4ef2ba3dc511150c28c8_Out_0 = _Metallic;
            half _Property_b3f728e4a7964f72b1738931df8788dc_Out_0 = _Smoothness;
            surface.BaseColor = (_Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = half3(0, 0, 0);
            surface.Metallic = _Property_4c3a908b10dc4ef2ba3dc511150c28c8_Out_0;
            surface.Specular = IsGammaSpace() ? half3(0.5, 0.5, 0.5) : SRGBToLinear(half3(0.5, 0.5, 0.5));
            surface.Smoothness = _Property_b3f728e4a7964f72b1738931df8788dc_Out_0;
            surface.Occlusion = 1;
            surface.Alpha = 1;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal = input.normalOS;
            output.ObjectSpaceTangent = input.tangentOS.xyz;
            output.ObjectSpacePosition = input.positionOS;

            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

        #endif





            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


            output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
        }

        // --------------------------------------------------
        // Main

        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif

        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }

            // Render State
            Cull[_Cull]
            Blend[_SrcBlend][_DstBlend]
            ZTest[_ZTest]
            ZWrite[_ZWrite]

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
            #pragma exclude_renderers gles gles3 glcore
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            #pragma instancing_options renderinglayer
            #pragma multi_compile _ DOTS_INSTANCING_ON
            #pragma vertex vert
            #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
            #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
            // GraphKeywords: <None>

            // Defines

            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SHADOW_COORD
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_GBUFFER
            #define _FOG_FRAGMENT 1
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


            // custom interpolator pre-include
            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            // custom interpolators pre packing
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

            struct Attributes
            {
                 float3 positionOS : POSITION;
                 float3 normalOS : NORMAL;
                 float4 tangentOS : TANGENT;
                 float4 uv1 : TEXCOORD1;
                 float4 uv2 : TEXCOORD2;
                #if UNITY_ANY_INSTANCING_ENABLED
                 uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
            struct Varyings
            {
                 float4 positionCS : SV_POSITION;
                 float3 positionWS;
                 float3 normalWS;
                 float4 tangentWS;
                 float3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                 float2 staticLightmapUV;
                #endif
                #if defined(DYNAMICLIGHTMAP_ON)
                 float2 dynamicLightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                 float3 sh;
                #endif
                 float4 fogFactorAndVertexLight;
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                 float4 shadowCoord;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                 uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            struct SurfaceDescriptionInputs
            {
                 float3 TangentSpaceNormal;
                 float3 ObjectSpacePosition;
                 float3 AbsoluteWorldSpacePosition;
            };
            struct VertexDescriptionInputs
            {
                 float3 ObjectSpaceNormal;
                 float3 ObjectSpaceTangent;
                 float3 ObjectSpacePosition;
            };
            struct PackedVaryings
            {
                 float4 positionCS : SV_POSITION;
                 float3 interp0 : INTERP0;
                 float3 interp1 : INTERP1;
                 float4 interp2 : INTERP2;
                 float3 interp3 : INTERP3;
                 float2 interp4 : INTERP4;
                 float2 interp5 : INTERP5;
                 float3 interp6 : INTERP6;
                 float4 interp7 : INTERP7;
                 float4 interp8 : INTERP8;
                #if UNITY_ANY_INSTANCING_ENABLED
                 uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                ZERO_INITIALIZE(PackedVaryings, output);
                output.positionCS = input.positionCS;
                output.interp0.xyz = input.positionWS;
                output.interp1.xyz = input.normalWS;
                output.interp2.xyzw = input.tangentWS;
                output.interp3.xyz = input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp4.xy = input.staticLightmapUV;
                #endif
                #if defined(DYNAMICLIGHTMAP_ON)
                output.interp5.xy = input.dynamicLightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp6.xyz = input.sh;
                #endif
                output.interp7.xyzw = input.fogFactorAndVertexLight;
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                output.interp8.xyzw = input.shadowCoord;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp0.xyz;
                output.normalWS = input.interp1.xyz;
                output.tangentWS = input.interp2.xyzw;
                output.viewDirectionWS = input.interp3.xyz;
                #if defined(LIGHTMAP_ON)
                output.staticLightmapUV = input.interp4.xy;
                #endif
                #if defined(DYNAMICLIGHTMAP_ON)
                output.dynamicLightmapUV = input.interp5.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp6.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp7.xyzw;
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                output.shadowCoord = input.interp8.xyzw;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }


            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            half _Edge;
            half4 _BaseColor;
            half4 _ReplaceableColor;
            half _NoiseScale;
            half _NormalizeCoefficient;
            half _Smoothness;
            half _Metallic;
            CBUFFER_END

                // Object and Global properties

                // Graph Includes
                // GraphIncludes: <None>

                // -- Property used by ScenePickingPass
                #ifdef SCENEPICKINGPASS
                float4 _SelectionID;
                #endif

            // -- Properties used by SceneSelectionPass
            #ifdef SCENESELECTIONPASS
            int _ObjectId;
            int _PassValue;
            #endif

            // Graph Functions

            void Unity_Distance_float2(float2 A, float2 B, out float Out)
            {
                Out = distance(A, B);
            }

            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }


            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                // need full precision, otherwise half overflows when p > 1
                float x = float(34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }

            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            {
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }

            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }

            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }

            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }

            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }

            // Custom interpolators pre vertex
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

            // Graph Vertex
            struct VertexDescription
            {
                half3 Position;
                half3 Normal;
                half3 Tangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                description.Position = IN.ObjectSpacePosition;
                description.Normal = IN.ObjectSpaceNormal;
                description.Tangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif

            // Graph Pixel
            struct SurfaceDescription
            {
                float3 BaseColor;
                half3 NormalTS;
                half3 Emission;
                half Metallic;
                half3 Specular;
                half Smoothness;
                half Occlusion;
                half Alpha;
                half AlphaClipThreshold;
            };

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                half4 _Property_ffa90d3b3f77485e984796da11d0ac19_Out_0 = _BaseColor;
                half _Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0 = _Edge;
                float _Split_781cad85a9f046a8980ed2a1d2d10664_R_1 = IN.ObjectSpacePosition[0];
                float _Split_781cad85a9f046a8980ed2a1d2d10664_G_2 = IN.ObjectSpacePosition[1];
                float _Split_781cad85a9f046a8980ed2a1d2d10664_B_3 = IN.ObjectSpacePosition[2];
                float _Split_781cad85a9f046a8980ed2a1d2d10664_A_4 = 0;
                float2 _Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0 = float2(_Split_781cad85a9f046a8980ed2a1d2d10664_R_1, _Split_781cad85a9f046a8980ed2a1d2d10664_B_3);
                float _Distance_767d57b101584aec91e1737df8c8189a_Out_2;
                Unity_Distance_float2(_Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0, float2(0, 0), _Distance_767d57b101584aec91e1737df8c8189a_Out_2);
                half _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0 = _NormalizeCoefficient;
                float _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2;
                Unity_Divide_float(_Distance_767d57b101584aec91e1737df8c8189a_Out_2, _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0, _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2);
                float _Split_0adf1cac2e75421a859d31b60cd64966_R_1 = IN.AbsoluteWorldSpacePosition[0];
                float _Split_0adf1cac2e75421a859d31b60cd64966_G_2 = IN.AbsoluteWorldSpacePosition[1];
                float _Split_0adf1cac2e75421a859d31b60cd64966_B_3 = IN.AbsoluteWorldSpacePosition[2];
                float _Split_0adf1cac2e75421a859d31b60cd64966_A_4 = 0;
                float2 _Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0 = float2(_Split_0adf1cac2e75421a859d31b60cd64966_R_1, _Split_0adf1cac2e75421a859d31b60cd64966_B_3);
                half _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0 = _NoiseScale;
                float _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2;
                Unity_GradientNoise_float(_Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0, _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2);
                float _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2;
                Unity_Add_float(_Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2);
                float _Step_737f617fc2ec402a993374a78d94cdff_Out_2;
                Unity_Step_float(_Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2, _Step_737f617fc2ec402a993374a78d94cdff_Out_2);
                float4 _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2;
                Unity_Multiply_float4_float4(_Property_ffa90d3b3f77485e984796da11d0ac19_Out_0, (_Step_737f617fc2ec402a993374a78d94cdff_Out_2.xxxx), _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2);
                float _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1;
                Unity_OneMinus_float(_Step_737f617fc2ec402a993374a78d94cdff_Out_2, _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1);
                half4 _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0 = _ReplaceableColor;
                float4 _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2;
                Unity_Multiply_float4_float4((_OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1.xxxx), _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2);
                float4 _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2;
                Unity_Add_float4(_Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2, _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2);
                half _Property_4c3a908b10dc4ef2ba3dc511150c28c8_Out_0 = _Metallic;
                half _Property_b3f728e4a7964f72b1738931df8788dc_Out_0 = _Smoothness;
                surface.BaseColor = (_Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2.xyz);
                surface.NormalTS = IN.TangentSpaceNormal;
                surface.Emission = half3(0, 0, 0);
                surface.Metallic = _Property_4c3a908b10dc4ef2ba3dc511150c28c8_Out_0;
                surface.Specular = IsGammaSpace() ? half3(0.5, 0.5, 0.5) : SRGBToLinear(half3(0.5, 0.5, 0.5));
                surface.Smoothness = _Property_b3f728e4a7964f72b1738931df8788dc_Out_0;
                surface.Occlusion = 1;
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }

            // --------------------------------------------------
            // Build Graph Inputs
            #ifdef HAVE_VFX_MODIFICATION
            #define VFX_SRP_ATTRIBUTES Attributes
            #define VFX_SRP_VARYINGS Varyings
            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
            #endif
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal = input.normalOS;
                output.ObjectSpaceTangent = input.tangentOS.xyz;
                output.ObjectSpacePosition = input.positionOS;

                return output;
            }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

            #ifdef HAVE_VFX_MODIFICATION
                // FragInputs from VFX come from two places: Interpolator or CBuffer.
                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

            #endif





                output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
                output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                    return output;
            }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

            // --------------------------------------------------
            // Visual Effect Vertex Invocations
            #ifdef HAVE_VFX_MODIFICATION
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
            #endif

            ENDHLSL
            }
            Pass
            {
                Name "ShadowCaster"
                Tags
                {
                    "LightMode" = "ShadowCaster"
                }

                // Render State
                Cull[_Cull]
                ZTest LEqual
                ZWrite On
                ColorMask 0

                // Debug
                // <None>

                // --------------------------------------------------
                // Pass

                HLSLPROGRAM

                // Pragmas
                #pragma target 4.5
                #pragma exclude_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma multi_compile _ DOTS_INSTANCING_ON
                #pragma vertex vert
                #pragma fragment frag

                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>

                // Keywords
                #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                // GraphKeywords: <None>

                // Defines

                #define _NORMALMAP 1
                #define _NORMAL_DROPOFF_TS 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define VARYINGS_NEED_NORMAL_WS
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_SHADOWCASTER
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                // custom interpolator pre-include
                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                // --------------------------------------------------
                // Structs and Packing

                // custom interpolators pre packing
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float3 interp0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                PackedVaryings PackVaryings(Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.interp0.xyz = input.normalWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                Varyings UnpackVaryings(PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.normalWS = input.interp0.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }


                // --------------------------------------------------
                // Graph

                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                half _Edge;
                half4 _BaseColor;
                half4 _ReplaceableColor;
                half _NoiseScale;
                half _NormalizeCoefficient;
                half _Smoothness;
                half _Metallic;
                CBUFFER_END

                    // Object and Global properties

                    // Graph Includes
                    // GraphIncludes: <None>

                    // -- Property used by ScenePickingPass
                    #ifdef SCENEPICKINGPASS
                    float4 _SelectionID;
                    #endif

                // -- Properties used by SceneSelectionPass
                #ifdef SCENESELECTIONPASS
                int _ObjectId;
                int _PassValue;
                #endif

                // Graph Functions
                // GraphFunctions: <None>

                // Custom interpolators pre vertex
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                // Graph Vertex
                struct VertexDescription
                {
                    half3 Position;
                    half3 Normal;
                    half3 Tangent;
                };

                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }

                // Custom interpolators, pre surface
                #ifdef FEATURES_GRAPH_VERTEX
                Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                {
                return output;
                }
                #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                #endif

                // Graph Pixel
                struct SurfaceDescription
                {
                    half Alpha;
                    half AlphaClipThreshold;
                };

                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    surface.Alpha = 1;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }

                // --------------------------------------------------
                // Build Graph Inputs
                #ifdef HAVE_VFX_MODIFICATION
                #define VFX_SRP_ATTRIBUTES Attributes
                #define VFX_SRP_VARYINGS Varyings
                #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                #endif
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                    output.ObjectSpaceNormal = input.normalOS;
                    output.ObjectSpaceTangent = input.tangentOS.xyz;
                    output.ObjectSpacePosition = input.positionOS;

                    return output;
                }
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                #ifdef HAVE_VFX_MODIFICATION
                    // FragInputs from VFX come from two places: Interpolator or CBuffer.
                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                #endif







                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                        return output;
                }

                // --------------------------------------------------
                // Main

                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

                // --------------------------------------------------
                // Visual Effect Vertex Invocations
                #ifdef HAVE_VFX_MODIFICATION
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                #endif

                ENDHLSL
                }
                Pass
                {
                    Name "DepthOnly"
                    Tags
                    {
                        "LightMode" = "DepthOnly"
                    }

                    // Render State
                    Cull[_Cull]
                    ZTest LEqual
                    ZWrite On
                    ColorMask 0

                    // Debug
                    // <None>

                    // --------------------------------------------------
                    // Pass

                    HLSLPROGRAM

                    // Pragmas
                    #pragma target 4.5
                    #pragma exclude_renderers gles gles3 glcore
                    #pragma multi_compile_instancing
                    #pragma multi_compile _ DOTS_INSTANCING_ON
                    #pragma vertex vert
                    #pragma fragment frag

                    // DotsInstancingOptions: <None>
                    // HybridV1InjectedBuiltinProperties: <None>

                    // Keywords
                    #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                    // GraphKeywords: <None>

                    // Defines

                    #define _NORMALMAP 1
                    #define _NORMAL_DROPOFF_TS 1
                    #define ATTRIBUTES_NEED_NORMAL
                    #define ATTRIBUTES_NEED_TANGENT
                    #define FEATURES_GRAPH_VERTEX
                    /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                    #define SHADERPASS SHADERPASS_DEPTHONLY
                    /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                    // custom interpolator pre-include
                    /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                    // Includes
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                    // --------------------------------------------------
                    // Structs and Packing

                    // custom interpolators pre packing
                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                    struct Attributes
                    {
                         float3 positionOS : POSITION;
                         float3 normalOS : NORMAL;
                         float4 tangentOS : TANGENT;
                        #if UNITY_ANY_INSTANCING_ENABLED
                         uint instanceID : INSTANCEID_SEMANTIC;
                        #endif
                    };
                    struct Varyings
                    {
                         float4 positionCS : SV_POSITION;
                        #if UNITY_ANY_INSTANCING_ENABLED
                         uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };
                    struct SurfaceDescriptionInputs
                    {
                    };
                    struct VertexDescriptionInputs
                    {
                         float3 ObjectSpaceNormal;
                         float3 ObjectSpaceTangent;
                         float3 ObjectSpacePosition;
                    };
                    struct PackedVaryings
                    {
                         float4 positionCS : SV_POSITION;
                        #if UNITY_ANY_INSTANCING_ENABLED
                         uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };

                    PackedVaryings PackVaryings(Varyings input)
                    {
                        PackedVaryings output;
                        ZERO_INITIALIZE(PackedVaryings, output);
                        output.positionCS = input.positionCS;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }

                    Varyings UnpackVaryings(PackedVaryings input)
                    {
                        Varyings output;
                        output.positionCS = input.positionCS;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }


                    // --------------------------------------------------
                    // Graph

                    // Graph Properties
                    CBUFFER_START(UnityPerMaterial)
                    half _Edge;
                    half4 _BaseColor;
                    half4 _ReplaceableColor;
                    half _NoiseScale;
                    half _NormalizeCoefficient;
                    half _Smoothness;
                    half _Metallic;
                    CBUFFER_END

                        // Object and Global properties

                        // Graph Includes
                        // GraphIncludes: <None>

                        // -- Property used by ScenePickingPass
                        #ifdef SCENEPICKINGPASS
                        float4 _SelectionID;
                        #endif

                    // -- Properties used by SceneSelectionPass
                    #ifdef SCENESELECTIONPASS
                    int _ObjectId;
                    int _PassValue;
                    #endif

                    // Graph Functions
                    // GraphFunctions: <None>

                    // Custom interpolators pre vertex
                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                    // Graph Vertex
                    struct VertexDescription
                    {
                        half3 Position;
                        half3 Normal;
                        half3 Tangent;
                    };

                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        description.Position = IN.ObjectSpacePosition;
                        description.Normal = IN.ObjectSpaceNormal;
                        description.Tangent = IN.ObjectSpaceTangent;
                        return description;
                    }

                    // Custom interpolators, pre surface
                    #ifdef FEATURES_GRAPH_VERTEX
                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                    {
                    return output;
                    }
                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                    #endif

                    // Graph Pixel
                    struct SurfaceDescription
                    {
                        half Alpha;
                        half AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        surface.Alpha = 1;
                        surface.AlphaClipThreshold = 0.5;
                        return surface;
                    }

                    // --------------------------------------------------
                    // Build Graph Inputs
                    #ifdef HAVE_VFX_MODIFICATION
                    #define VFX_SRP_ATTRIBUTES Attributes
                    #define VFX_SRP_VARYINGS Varyings
                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                    #endif
                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                    {
                        VertexDescriptionInputs output;
                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                        output.ObjectSpaceNormal = input.normalOS;
                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                        output.ObjectSpacePosition = input.positionOS;

                        return output;
                    }
                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                    {
                        SurfaceDescriptionInputs output;
                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                    #ifdef HAVE_VFX_MODIFICATION
                        // FragInputs from VFX come from two places: Interpolator or CBuffer.
                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                    #endif







                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                    #else
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                    #endif
                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                            return output;
                    }

                    // --------------------------------------------------
                    // Main

                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

                    // --------------------------------------------------
                    // Visual Effect Vertex Invocations
                    #ifdef HAVE_VFX_MODIFICATION
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                    #endif

                    ENDHLSL
                    }
                    Pass
                    {
                        Name "DepthNormals"
                        Tags
                        {
                            "LightMode" = "DepthNormals"
                        }

                        // Render State
                        Cull[_Cull]
                        ZTest LEqual
                        ZWrite On

                        // Debug
                        // <None>

                        // --------------------------------------------------
                        // Pass

                        HLSLPROGRAM

                        // Pragmas
                        #pragma target 4.5
                        #pragma exclude_renderers gles gles3 glcore
                        #pragma multi_compile_instancing
                        #pragma multi_compile _ DOTS_INSTANCING_ON
                        #pragma vertex vert
                        #pragma fragment frag

                        // DotsInstancingOptions: <None>
                        // HybridV1InjectedBuiltinProperties: <None>

                        // Keywords
                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                        // GraphKeywords: <None>

                        // Defines

                        #define _NORMALMAP 1
                        #define _NORMAL_DROPOFF_TS 1
                        #define ATTRIBUTES_NEED_NORMAL
                        #define ATTRIBUTES_NEED_TANGENT
                        #define ATTRIBUTES_NEED_TEXCOORD1
                        #define VARYINGS_NEED_NORMAL_WS
                        #define VARYINGS_NEED_TANGENT_WS
                        #define FEATURES_GRAPH_VERTEX
                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                        #define SHADERPASS SHADERPASS_DEPTHNORMALS
                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                        // custom interpolator pre-include
                        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                        // Includes
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                        // --------------------------------------------------
                        // Structs and Packing

                        // custom interpolators pre packing
                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                        struct Attributes
                        {
                             float3 positionOS : POSITION;
                             float3 normalOS : NORMAL;
                             float4 tangentOS : TANGENT;
                             float4 uv1 : TEXCOORD1;
                            #if UNITY_ANY_INSTANCING_ENABLED
                             uint instanceID : INSTANCEID_SEMANTIC;
                            #endif
                        };
                        struct Varyings
                        {
                             float4 positionCS : SV_POSITION;
                             float3 normalWS;
                             float4 tangentWS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                             uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };
                        struct SurfaceDescriptionInputs
                        {
                             float3 TangentSpaceNormal;
                        };
                        struct VertexDescriptionInputs
                        {
                             float3 ObjectSpaceNormal;
                             float3 ObjectSpaceTangent;
                             float3 ObjectSpacePosition;
                        };
                        struct PackedVaryings
                        {
                             float4 positionCS : SV_POSITION;
                             float3 interp0 : INTERP0;
                             float4 interp1 : INTERP1;
                            #if UNITY_ANY_INSTANCING_ENABLED
                             uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        PackedVaryings PackVaryings(Varyings input)
                        {
                            PackedVaryings output;
                            ZERO_INITIALIZE(PackedVaryings, output);
                            output.positionCS = input.positionCS;
                            output.interp0.xyz = input.normalWS;
                            output.interp1.xyzw = input.tangentWS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        Varyings UnpackVaryings(PackedVaryings input)
                        {
                            Varyings output;
                            output.positionCS = input.positionCS;
                            output.normalWS = input.interp0.xyz;
                            output.tangentWS = input.interp1.xyzw;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }


                        // --------------------------------------------------
                        // Graph

                        // Graph Properties
                        CBUFFER_START(UnityPerMaterial)
                        half _Edge;
                        half4 _BaseColor;
                        half4 _ReplaceableColor;
                        half _NoiseScale;
                        half _NormalizeCoefficient;
                        half _Smoothness;
                        half _Metallic;
                        CBUFFER_END

                            // Object and Global properties

                            // Graph Includes
                            // GraphIncludes: <None>

                            // -- Property used by ScenePickingPass
                            #ifdef SCENEPICKINGPASS
                            float4 _SelectionID;
                            #endif

                        // -- Properties used by SceneSelectionPass
                        #ifdef SCENESELECTIONPASS
                        int _ObjectId;
                        int _PassValue;
                        #endif

                        // Graph Functions
                        // GraphFunctions: <None>

                        // Custom interpolators pre vertex
                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                        // Graph Vertex
                        struct VertexDescription
                        {
                            half3 Position;
                            half3 Normal;
                            half3 Tangent;
                        };

                        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                        {
                            VertexDescription description = (VertexDescription)0;
                            description.Position = IN.ObjectSpacePosition;
                            description.Normal = IN.ObjectSpaceNormal;
                            description.Tangent = IN.ObjectSpaceTangent;
                            return description;
                        }

                        // Custom interpolators, pre surface
                        #ifdef FEATURES_GRAPH_VERTEX
                        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                        {
                        return output;
                        }
                        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                        #endif

                        // Graph Pixel
                        struct SurfaceDescription
                        {
                            half3 NormalTS;
                            half Alpha;
                            half AlphaClipThreshold;
                        };

                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                        {
                            SurfaceDescription surface = (SurfaceDescription)0;
                            surface.NormalTS = IN.TangentSpaceNormal;
                            surface.Alpha = 1;
                            surface.AlphaClipThreshold = 0.5;
                            return surface;
                        }

                        // --------------------------------------------------
                        // Build Graph Inputs
                        #ifdef HAVE_VFX_MODIFICATION
                        #define VFX_SRP_ATTRIBUTES Attributes
                        #define VFX_SRP_VARYINGS Varyings
                        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                        #endif
                        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                        {
                            VertexDescriptionInputs output;
                            ZERO_INITIALIZE(VertexDescriptionInputs, output);

                            output.ObjectSpaceNormal = input.normalOS;
                            output.ObjectSpaceTangent = input.tangentOS.xyz;
                            output.ObjectSpacePosition = input.positionOS;

                            return output;
                        }
                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                        {
                            SurfaceDescriptionInputs output;
                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                        #ifdef HAVE_VFX_MODIFICATION
                            // FragInputs from VFX come from two places: Interpolator or CBuffer.
                            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                        #endif





                            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                        #else
                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                        #endif
                        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                return output;
                        }

                        // --------------------------------------------------
                        // Main

                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

                        // --------------------------------------------------
                        // Visual Effect Vertex Invocations
                        #ifdef HAVE_VFX_MODIFICATION
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                        #endif

                        ENDHLSL
                        }
                        Pass
                        {
                            Name "Meta"
                            Tags
                            {
                                "LightMode" = "Meta"
                            }

                            // Render State
                            Cull Off

                            // Debug
                            // <None>

                            // --------------------------------------------------
                            // Pass

                            HLSLPROGRAM

                            // Pragmas
                            #pragma target 4.5
                            #pragma exclude_renderers gles gles3 glcore
                            #pragma vertex vert
                            #pragma fragment frag

                            // DotsInstancingOptions: <None>
                            // HybridV1InjectedBuiltinProperties: <None>

                            // Keywords
                            #pragma shader_feature _ EDITOR_VISUALIZATION
                            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                            // GraphKeywords: <None>

                            // Defines

                            #define _NORMALMAP 1
                            #define _NORMAL_DROPOFF_TS 1
                            #define ATTRIBUTES_NEED_NORMAL
                            #define ATTRIBUTES_NEED_TANGENT
                            #define ATTRIBUTES_NEED_TEXCOORD0
                            #define ATTRIBUTES_NEED_TEXCOORD1
                            #define ATTRIBUTES_NEED_TEXCOORD2
                            #define VARYINGS_NEED_POSITION_WS
                            #define VARYINGS_NEED_TEXCOORD0
                            #define VARYINGS_NEED_TEXCOORD1
                            #define VARYINGS_NEED_TEXCOORD2
                            #define FEATURES_GRAPH_VERTEX
                            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                            #define SHADERPASS SHADERPASS_META
                            #define _FOG_FRAGMENT 1
                            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                            // custom interpolator pre-include
                            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                            // Includes
                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                            // --------------------------------------------------
                            // Structs and Packing

                            // custom interpolators pre packing
                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                            struct Attributes
                            {
                                 float3 positionOS : POSITION;
                                 float3 normalOS : NORMAL;
                                 float4 tangentOS : TANGENT;
                                 float4 uv0 : TEXCOORD0;
                                 float4 uv1 : TEXCOORD1;
                                 float4 uv2 : TEXCOORD2;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                 uint instanceID : INSTANCEID_SEMANTIC;
                                #endif
                            };
                            struct Varyings
                            {
                                 float4 positionCS : SV_POSITION;
                                 float3 positionWS;
                                 float4 texCoord0;
                                 float4 texCoord1;
                                 float4 texCoord2;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                 uint instanceID : CUSTOM_INSTANCE_ID;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                #endif
                            };
                            struct SurfaceDescriptionInputs
                            {
                                 float3 ObjectSpacePosition;
                                 float3 AbsoluteWorldSpacePosition;
                            };
                            struct VertexDescriptionInputs
                            {
                                 float3 ObjectSpaceNormal;
                                 float3 ObjectSpaceTangent;
                                 float3 ObjectSpacePosition;
                            };
                            struct PackedVaryings
                            {
                                 float4 positionCS : SV_POSITION;
                                 float3 interp0 : INTERP0;
                                 float4 interp1 : INTERP1;
                                 float4 interp2 : INTERP2;
                                 float4 interp3 : INTERP3;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                 uint instanceID : CUSTOM_INSTANCE_ID;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                #endif
                            };

                            PackedVaryings PackVaryings(Varyings input)
                            {
                                PackedVaryings output;
                                ZERO_INITIALIZE(PackedVaryings, output);
                                output.positionCS = input.positionCS;
                                output.interp0.xyz = input.positionWS;
                                output.interp1.xyzw = input.texCoord0;
                                output.interp2.xyzw = input.texCoord1;
                                output.interp3.xyzw = input.texCoord2;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }

                            Varyings UnpackVaryings(PackedVaryings input)
                            {
                                Varyings output;
                                output.positionCS = input.positionCS;
                                output.positionWS = input.interp0.xyz;
                                output.texCoord0 = input.interp1.xyzw;
                                output.texCoord1 = input.interp2.xyzw;
                                output.texCoord2 = input.interp3.xyzw;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }


                            // --------------------------------------------------
                            // Graph

                            // Graph Properties
                            CBUFFER_START(UnityPerMaterial)
                            half _Edge;
                            half4 _BaseColor;
                            half4 _ReplaceableColor;
                            half _NoiseScale;
                            half _NormalizeCoefficient;
                            half _Smoothness;
                            half _Metallic;
                            CBUFFER_END

                                // Object and Global properties

                                // Graph Includes
                                // GraphIncludes: <None>

                                // -- Property used by ScenePickingPass
                                #ifdef SCENEPICKINGPASS
                                float4 _SelectionID;
                                #endif

                            // -- Properties used by SceneSelectionPass
                            #ifdef SCENESELECTIONPASS
                            int _ObjectId;
                            int _PassValue;
                            #endif

                            // Graph Functions

                            void Unity_Distance_float2(float2 A, float2 B, out float Out)
                            {
                                Out = distance(A, B);
                            }

                            void Unity_Divide_float(float A, float B, out float Out)
                            {
                                Out = A / B;
                            }


                            float2 Unity_GradientNoise_Dir_float(float2 p)
                            {
                                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                                p = p % 289;
                                // need full precision, otherwise half overflows when p > 1
                                float x = float(34 * p.x + 1) * p.x % 289 + p.y;
                                x = (34 * x + 1) * x % 289;
                                x = frac(x / 41) * 2 - 1;
                                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                            }

                            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                            {
                                float2 p = UV * Scale;
                                float2 ip = floor(p);
                                float2 fp = frac(p);
                                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                            }

                            void Unity_Add_float(float A, float B, out float Out)
                            {
                                Out = A + B;
                            }

                            void Unity_Step_float(float Edge, float In, out float Out)
                            {
                                Out = step(Edge, In);
                            }

                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                            {
                                Out = A * B;
                            }

                            void Unity_OneMinus_float(float In, out float Out)
                            {
                                Out = 1 - In;
                            }

                            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                            {
                                Out = A + B;
                            }

                            // Custom interpolators pre vertex
                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                            // Graph Vertex
                            struct VertexDescription
                            {
                                half3 Position;
                                half3 Normal;
                                half3 Tangent;
                            };

                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                            {
                                VertexDescription description = (VertexDescription)0;
                                description.Position = IN.ObjectSpacePosition;
                                description.Normal = IN.ObjectSpaceNormal;
                                description.Tangent = IN.ObjectSpaceTangent;
                                return description;
                            }

                            // Custom interpolators, pre surface
                            #ifdef FEATURES_GRAPH_VERTEX
                            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                            {
                            return output;
                            }
                            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                            #endif

                            // Graph Pixel
                            struct SurfaceDescription
                            {
                                float3 BaseColor;
                                half3 Emission;
                                half Alpha;
                                half AlphaClipThreshold;
                            };

                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                            {
                                SurfaceDescription surface = (SurfaceDescription)0;
                                half4 _Property_ffa90d3b3f77485e984796da11d0ac19_Out_0 = _BaseColor;
                                half _Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0 = _Edge;
                                float _Split_781cad85a9f046a8980ed2a1d2d10664_R_1 = IN.ObjectSpacePosition[0];
                                float _Split_781cad85a9f046a8980ed2a1d2d10664_G_2 = IN.ObjectSpacePosition[1];
                                float _Split_781cad85a9f046a8980ed2a1d2d10664_B_3 = IN.ObjectSpacePosition[2];
                                float _Split_781cad85a9f046a8980ed2a1d2d10664_A_4 = 0;
                                float2 _Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0 = float2(_Split_781cad85a9f046a8980ed2a1d2d10664_R_1, _Split_781cad85a9f046a8980ed2a1d2d10664_B_3);
                                float _Distance_767d57b101584aec91e1737df8c8189a_Out_2;
                                Unity_Distance_float2(_Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0, float2(0, 0), _Distance_767d57b101584aec91e1737df8c8189a_Out_2);
                                half _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0 = _NormalizeCoefficient;
                                float _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2;
                                Unity_Divide_float(_Distance_767d57b101584aec91e1737df8c8189a_Out_2, _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0, _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2);
                                float _Split_0adf1cac2e75421a859d31b60cd64966_R_1 = IN.AbsoluteWorldSpacePosition[0];
                                float _Split_0adf1cac2e75421a859d31b60cd64966_G_2 = IN.AbsoluteWorldSpacePosition[1];
                                float _Split_0adf1cac2e75421a859d31b60cd64966_B_3 = IN.AbsoluteWorldSpacePosition[2];
                                float _Split_0adf1cac2e75421a859d31b60cd64966_A_4 = 0;
                                float2 _Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0 = float2(_Split_0adf1cac2e75421a859d31b60cd64966_R_1, _Split_0adf1cac2e75421a859d31b60cd64966_B_3);
                                half _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0 = _NoiseScale;
                                float _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2;
                                Unity_GradientNoise_float(_Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0, _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2);
                                float _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2;
                                Unity_Add_float(_Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2);
                                float _Step_737f617fc2ec402a993374a78d94cdff_Out_2;
                                Unity_Step_float(_Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2, _Step_737f617fc2ec402a993374a78d94cdff_Out_2);
                                float4 _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2;
                                Unity_Multiply_float4_float4(_Property_ffa90d3b3f77485e984796da11d0ac19_Out_0, (_Step_737f617fc2ec402a993374a78d94cdff_Out_2.xxxx), _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2);
                                float _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1;
                                Unity_OneMinus_float(_Step_737f617fc2ec402a993374a78d94cdff_Out_2, _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1);
                                half4 _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0 = _ReplaceableColor;
                                float4 _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2;
                                Unity_Multiply_float4_float4((_OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1.xxxx), _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2);
                                float4 _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2;
                                Unity_Add_float4(_Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2, _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2);
                                surface.BaseColor = (_Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2.xyz);
                                surface.Emission = half3(0, 0, 0);
                                surface.Alpha = 1;
                                surface.AlphaClipThreshold = 0.5;
                                return surface;
                            }

                            // --------------------------------------------------
                            // Build Graph Inputs
                            #ifdef HAVE_VFX_MODIFICATION
                            #define VFX_SRP_ATTRIBUTES Attributes
                            #define VFX_SRP_VARYINGS Varyings
                            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                            #endif
                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                            {
                                VertexDescriptionInputs output;
                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                output.ObjectSpaceNormal = input.normalOS;
                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                output.ObjectSpacePosition = input.positionOS;

                                return output;
                            }
                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                            {
                                SurfaceDescriptionInputs output;
                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                            #ifdef HAVE_VFX_MODIFICATION
                                // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                            #endif







                                output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
                                output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                            #else
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                            #endif
                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                    return output;
                            }

                            // --------------------------------------------------
                            // Main

                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

                            // --------------------------------------------------
                            // Visual Effect Vertex Invocations
                            #ifdef HAVE_VFX_MODIFICATION
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                            #endif

                            ENDHLSL
                            }
                            Pass
                            {
                                Name "SceneSelectionPass"
                                Tags
                                {
                                    "LightMode" = "SceneSelectionPass"
                                }

                                // Render State
                                Cull Off

                                // Debug
                                // <None>

                                // --------------------------------------------------
                                // Pass

                                HLSLPROGRAM

                                // Pragmas
                                #pragma target 4.5
                                #pragma exclude_renderers gles gles3 glcore
                                #pragma vertex vert
                                #pragma fragment frag

                                // DotsInstancingOptions: <None>
                                // HybridV1InjectedBuiltinProperties: <None>

                                // Keywords
                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                // GraphKeywords: <None>

                                // Defines

                                #define _NORMALMAP 1
                                #define _NORMAL_DROPOFF_TS 1
                                #define ATTRIBUTES_NEED_NORMAL
                                #define ATTRIBUTES_NEED_TANGENT
                                #define FEATURES_GRAPH_VERTEX
                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                #define SHADERPASS SHADERPASS_DEPTHONLY
                                #define SCENESELECTIONPASS 1
                                #define ALPHA_CLIP_THRESHOLD 1
                                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                // custom interpolator pre-include
                                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                // Includes
                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                // --------------------------------------------------
                                // Structs and Packing

                                // custom interpolators pre packing
                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                struct Attributes
                                {
                                     float3 positionOS : POSITION;
                                     float3 normalOS : NORMAL;
                                     float4 tangentOS : TANGENT;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                     uint instanceID : INSTANCEID_SEMANTIC;
                                    #endif
                                };
                                struct Varyings
                                {
                                     float4 positionCS : SV_POSITION;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                    #endif
                                };
                                struct SurfaceDescriptionInputs
                                {
                                };
                                struct VertexDescriptionInputs
                                {
                                     float3 ObjectSpaceNormal;
                                     float3 ObjectSpaceTangent;
                                     float3 ObjectSpacePosition;
                                };
                                struct PackedVaryings
                                {
                                     float4 positionCS : SV_POSITION;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                    #endif
                                };

                                PackedVaryings PackVaryings(Varyings input)
                                {
                                    PackedVaryings output;
                                    ZERO_INITIALIZE(PackedVaryings, output);
                                    output.positionCS = input.positionCS;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                    output.instanceID = input.instanceID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                    output.cullFace = input.cullFace;
                                    #endif
                                    return output;
                                }

                                Varyings UnpackVaryings(PackedVaryings input)
                                {
                                    Varyings output;
                                    output.positionCS = input.positionCS;
                                    #if UNITY_ANY_INSTANCING_ENABLED
                                    output.instanceID = input.instanceID;
                                    #endif
                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                    #endif
                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                    #endif
                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                    output.cullFace = input.cullFace;
                                    #endif
                                    return output;
                                }


                                // --------------------------------------------------
                                // Graph

                                // Graph Properties
                                CBUFFER_START(UnityPerMaterial)
                                half _Edge;
                                half4 _BaseColor;
                                half4 _ReplaceableColor;
                                half _NoiseScale;
                                half _NormalizeCoefficient;
                                half _Smoothness;
                                half _Metallic;
                                CBUFFER_END

                                    // Object and Global properties

                                    // Graph Includes
                                    // GraphIncludes: <None>

                                    // -- Property used by ScenePickingPass
                                    #ifdef SCENEPICKINGPASS
                                    float4 _SelectionID;
                                    #endif

                                // -- Properties used by SceneSelectionPass
                                #ifdef SCENESELECTIONPASS
                                int _ObjectId;
                                int _PassValue;
                                #endif

                                // Graph Functions
                                // GraphFunctions: <None>

                                // Custom interpolators pre vertex
                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                // Graph Vertex
                                struct VertexDescription
                                {
                                    half3 Position;
                                    half3 Normal;
                                    half3 Tangent;
                                };

                                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                {
                                    VertexDescription description = (VertexDescription)0;
                                    description.Position = IN.ObjectSpacePosition;
                                    description.Normal = IN.ObjectSpaceNormal;
                                    description.Tangent = IN.ObjectSpaceTangent;
                                    return description;
                                }

                                // Custom interpolators, pre surface
                                #ifdef FEATURES_GRAPH_VERTEX
                                Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                {
                                return output;
                                }
                                #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                #endif

                                // Graph Pixel
                                struct SurfaceDescription
                                {
                                    half Alpha;
                                    half AlphaClipThreshold;
                                };

                                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                {
                                    SurfaceDescription surface = (SurfaceDescription)0;
                                    surface.Alpha = 1;
                                    surface.AlphaClipThreshold = 0.5;
                                    return surface;
                                }

                                // --------------------------------------------------
                                // Build Graph Inputs
                                #ifdef HAVE_VFX_MODIFICATION
                                #define VFX_SRP_ATTRIBUTES Attributes
                                #define VFX_SRP_VARYINGS Varyings
                                #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                #endif
                                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                {
                                    VertexDescriptionInputs output;
                                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                    output.ObjectSpaceNormal = input.normalOS;
                                    output.ObjectSpaceTangent = input.tangentOS.xyz;
                                    output.ObjectSpacePosition = input.positionOS;

                                    return output;
                                }
                                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                {
                                    SurfaceDescriptionInputs output;
                                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                #ifdef HAVE_VFX_MODIFICATION
                                    // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                #endif







                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                #else
                                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                #endif
                                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                        return output;
                                }

                                // --------------------------------------------------
                                // Main

                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

                                // --------------------------------------------------
                                // Visual Effect Vertex Invocations
                                #ifdef HAVE_VFX_MODIFICATION
                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                #endif

                                ENDHLSL
                                }
                                Pass
                                {
                                    Name "ScenePickingPass"
                                    Tags
                                    {
                                        "LightMode" = "Picking"
                                    }

                                    // Render State
                                    Cull[_Cull]

                                    // Debug
                                    // <None>

                                    // --------------------------------------------------
                                    // Pass

                                    HLSLPROGRAM

                                    // Pragmas
                                    #pragma target 4.5
                                    #pragma exclude_renderers gles gles3 glcore
                                    #pragma vertex vert
                                    #pragma fragment frag

                                    // DotsInstancingOptions: <None>
                                    // HybridV1InjectedBuiltinProperties: <None>

                                    // Keywords
                                    #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                    // GraphKeywords: <None>

                                    // Defines

                                    #define _NORMALMAP 1
                                    #define _NORMAL_DROPOFF_TS 1
                                    #define ATTRIBUTES_NEED_NORMAL
                                    #define ATTRIBUTES_NEED_TANGENT
                                    #define FEATURES_GRAPH_VERTEX
                                    /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                    #define SHADERPASS SHADERPASS_DEPTHONLY
                                    #define SCENEPICKINGPASS 1
                                    #define ALPHA_CLIP_THRESHOLD 1
                                    /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                    // custom interpolator pre-include
                                    /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                    // Includes
                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                    // --------------------------------------------------
                                    // Structs and Packing

                                    // custom interpolators pre packing
                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                    struct Attributes
                                    {
                                         float3 positionOS : POSITION;
                                         float3 normalOS : NORMAL;
                                         float4 tangentOS : TANGENT;
                                        #if UNITY_ANY_INSTANCING_ENABLED
                                         uint instanceID : INSTANCEID_SEMANTIC;
                                        #endif
                                    };
                                    struct Varyings
                                    {
                                         float4 positionCS : SV_POSITION;
                                        #if UNITY_ANY_INSTANCING_ENABLED
                                         uint instanceID : CUSTOM_INSTANCE_ID;
                                        #endif
                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                        #endif
                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                        #endif
                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                        #endif
                                    };
                                    struct SurfaceDescriptionInputs
                                    {
                                    };
                                    struct VertexDescriptionInputs
                                    {
                                         float3 ObjectSpaceNormal;
                                         float3 ObjectSpaceTangent;
                                         float3 ObjectSpacePosition;
                                    };
                                    struct PackedVaryings
                                    {
                                         float4 positionCS : SV_POSITION;
                                        #if UNITY_ANY_INSTANCING_ENABLED
                                         uint instanceID : CUSTOM_INSTANCE_ID;
                                        #endif
                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                        #endif
                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                        #endif
                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                        #endif
                                    };

                                    PackedVaryings PackVaryings(Varyings input)
                                    {
                                        PackedVaryings output;
                                        ZERO_INITIALIZE(PackedVaryings, output);
                                        output.positionCS = input.positionCS;
                                        #if UNITY_ANY_INSTANCING_ENABLED
                                        output.instanceID = input.instanceID;
                                        #endif
                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                        #endif
                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                        #endif
                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                        output.cullFace = input.cullFace;
                                        #endif
                                        return output;
                                    }

                                    Varyings UnpackVaryings(PackedVaryings input)
                                    {
                                        Varyings output;
                                        output.positionCS = input.positionCS;
                                        #if UNITY_ANY_INSTANCING_ENABLED
                                        output.instanceID = input.instanceID;
                                        #endif
                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                        #endif
                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                        #endif
                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                        output.cullFace = input.cullFace;
                                        #endif
                                        return output;
                                    }


                                    // --------------------------------------------------
                                    // Graph

                                    // Graph Properties
                                    CBUFFER_START(UnityPerMaterial)
                                    half _Edge;
                                    half4 _BaseColor;
                                    half4 _ReplaceableColor;
                                    half _NoiseScale;
                                    half _NormalizeCoefficient;
                                    half _Smoothness;
                                    half _Metallic;
                                    CBUFFER_END

                                        // Object and Global properties

                                        // Graph Includes
                                        // GraphIncludes: <None>

                                        // -- Property used by ScenePickingPass
                                        #ifdef SCENEPICKINGPASS
                                        float4 _SelectionID;
                                        #endif

                                    // -- Properties used by SceneSelectionPass
                                    #ifdef SCENESELECTIONPASS
                                    int _ObjectId;
                                    int _PassValue;
                                    #endif

                                    // Graph Functions
                                    // GraphFunctions: <None>

                                    // Custom interpolators pre vertex
                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                    // Graph Vertex
                                    struct VertexDescription
                                    {
                                        half3 Position;
                                        half3 Normal;
                                        half3 Tangent;
                                    };

                                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                    {
                                        VertexDescription description = (VertexDescription)0;
                                        description.Position = IN.ObjectSpacePosition;
                                        description.Normal = IN.ObjectSpaceNormal;
                                        description.Tangent = IN.ObjectSpaceTangent;
                                        return description;
                                    }

                                    // Custom interpolators, pre surface
                                    #ifdef FEATURES_GRAPH_VERTEX
                                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                    {
                                    return output;
                                    }
                                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                    #endif

                                    // Graph Pixel
                                    struct SurfaceDescription
                                    {
                                        half Alpha;
                                        half AlphaClipThreshold;
                                    };

                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                    {
                                        SurfaceDescription surface = (SurfaceDescription)0;
                                        surface.Alpha = 1;
                                        surface.AlphaClipThreshold = 0.5;
                                        return surface;
                                    }

                                    // --------------------------------------------------
                                    // Build Graph Inputs
                                    #ifdef HAVE_VFX_MODIFICATION
                                    #define VFX_SRP_ATTRIBUTES Attributes
                                    #define VFX_SRP_VARYINGS Varyings
                                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                    #endif
                                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                    {
                                        VertexDescriptionInputs output;
                                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                        output.ObjectSpaceNormal = input.normalOS;
                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                        output.ObjectSpacePosition = input.positionOS;

                                        return output;
                                    }
                                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                    {
                                        SurfaceDescriptionInputs output;
                                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                    #ifdef HAVE_VFX_MODIFICATION
                                        // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                    #endif







                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                    #else
                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                    #endif
                                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                            return output;
                                    }

                                    // --------------------------------------------------
                                    // Main

                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

                                    // --------------------------------------------------
                                    // Visual Effect Vertex Invocations
                                    #ifdef HAVE_VFX_MODIFICATION
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                    #endif

                                    ENDHLSL
                                    }
                                    Pass
                                    {
                                        // Name: <None>
                                        Tags
                                        {
                                            "LightMode" = "Universal2D"
                                        }

                                        // Render State
                                        Cull[_Cull]
                                        Blend[_SrcBlend][_DstBlend]
                                        ZTest[_ZTest]
                                        ZWrite[_ZWrite]

                                        // Debug
                                        // <None>

                                        // --------------------------------------------------
                                        // Pass

                                        HLSLPROGRAM

                                        // Pragmas
                                        #pragma target 4.5
                                        #pragma exclude_renderers gles gles3 glcore
                                        #pragma vertex vert
                                        #pragma fragment frag

                                        // DotsInstancingOptions: <None>
                                        // HybridV1InjectedBuiltinProperties: <None>

                                        // Keywords
                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                        // GraphKeywords: <None>

                                        // Defines

                                        #define _NORMALMAP 1
                                        #define _NORMAL_DROPOFF_TS 1
                                        #define ATTRIBUTES_NEED_NORMAL
                                        #define ATTRIBUTES_NEED_TANGENT
                                        #define VARYINGS_NEED_POSITION_WS
                                        #define FEATURES_GRAPH_VERTEX
                                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                        #define SHADERPASS SHADERPASS_2D
                                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                        // custom interpolator pre-include
                                        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                        // Includes
                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                        // --------------------------------------------------
                                        // Structs and Packing

                                        // custom interpolators pre packing
                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                        struct Attributes
                                        {
                                             float3 positionOS : POSITION;
                                             float3 normalOS : NORMAL;
                                             float4 tangentOS : TANGENT;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                             uint instanceID : INSTANCEID_SEMANTIC;
                                            #endif
                                        };
                                        struct Varyings
                                        {
                                             float4 positionCS : SV_POSITION;
                                             float3 positionWS;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                            #endif
                                        };
                                        struct SurfaceDescriptionInputs
                                        {
                                             float3 ObjectSpacePosition;
                                             float3 AbsoluteWorldSpacePosition;
                                        };
                                        struct VertexDescriptionInputs
                                        {
                                             float3 ObjectSpaceNormal;
                                             float3 ObjectSpaceTangent;
                                             float3 ObjectSpacePosition;
                                        };
                                        struct PackedVaryings
                                        {
                                             float4 positionCS : SV_POSITION;
                                             float3 interp0 : INTERP0;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                            #endif
                                        };

                                        PackedVaryings PackVaryings(Varyings input)
                                        {
                                            PackedVaryings output;
                                            ZERO_INITIALIZE(PackedVaryings, output);
                                            output.positionCS = input.positionCS;
                                            output.interp0.xyz = input.positionWS;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                            output.instanceID = input.instanceID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            output.cullFace = input.cullFace;
                                            #endif
                                            return output;
                                        }

                                        Varyings UnpackVaryings(PackedVaryings input)
                                        {
                                            Varyings output;
                                            output.positionCS = input.positionCS;
                                            output.positionWS = input.interp0.xyz;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                            output.instanceID = input.instanceID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            output.cullFace = input.cullFace;
                                            #endif
                                            return output;
                                        }


                                        // --------------------------------------------------
                                        // Graph

                                        // Graph Properties
                                        CBUFFER_START(UnityPerMaterial)
                                        half _Edge;
                                        half4 _BaseColor;
                                        half4 _ReplaceableColor;
                                        half _NoiseScale;
                                        half _NormalizeCoefficient;
                                        half _Smoothness;
                                        half _Metallic;
                                        CBUFFER_END

                                            // Object and Global properties

                                            // Graph Includes
                                            // GraphIncludes: <None>

                                            // -- Property used by ScenePickingPass
                                            #ifdef SCENEPICKINGPASS
                                            float4 _SelectionID;
                                            #endif

                                        // -- Properties used by SceneSelectionPass
                                        #ifdef SCENESELECTIONPASS
                                        int _ObjectId;
                                        int _PassValue;
                                        #endif

                                        // Graph Functions

                                        void Unity_Distance_float2(float2 A, float2 B, out float Out)
                                        {
                                            Out = distance(A, B);
                                        }

                                        void Unity_Divide_float(float A, float B, out float Out)
                                        {
                                            Out = A / B;
                                        }


                                        float2 Unity_GradientNoise_Dir_float(float2 p)
                                        {
                                            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                                            p = p % 289;
                                            // need full precision, otherwise half overflows when p > 1
                                            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
                                            x = (34 * x + 1) * x % 289;
                                            x = frac(x / 41) * 2 - 1;
                                            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                                        }

                                        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                                        {
                                            float2 p = UV * Scale;
                                            float2 ip = floor(p);
                                            float2 fp = frac(p);
                                            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                                            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                                        }

                                        void Unity_Add_float(float A, float B, out float Out)
                                        {
                                            Out = A + B;
                                        }

                                        void Unity_Step_float(float Edge, float In, out float Out)
                                        {
                                            Out = step(Edge, In);
                                        }

                                        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                        {
                                            Out = A * B;
                                        }

                                        void Unity_OneMinus_float(float In, out float Out)
                                        {
                                            Out = 1 - In;
                                        }

                                        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                                        {
                                            Out = A + B;
                                        }

                                        // Custom interpolators pre vertex
                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                        // Graph Vertex
                                        struct VertexDescription
                                        {
                                            half3 Position;
                                            half3 Normal;
                                            half3 Tangent;
                                        };

                                        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                        {
                                            VertexDescription description = (VertexDescription)0;
                                            description.Position = IN.ObjectSpacePosition;
                                            description.Normal = IN.ObjectSpaceNormal;
                                            description.Tangent = IN.ObjectSpaceTangent;
                                            return description;
                                        }

                                        // Custom interpolators, pre surface
                                        #ifdef FEATURES_GRAPH_VERTEX
                                        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                        {
                                        return output;
                                        }
                                        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                        #endif

                                        // Graph Pixel
                                        struct SurfaceDescription
                                        {
                                            float3 BaseColor;
                                            half Alpha;
                                            half AlphaClipThreshold;
                                        };

                                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                        {
                                            SurfaceDescription surface = (SurfaceDescription)0;
                                            half4 _Property_ffa90d3b3f77485e984796da11d0ac19_Out_0 = _BaseColor;
                                            half _Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0 = _Edge;
                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_R_1 = IN.ObjectSpacePosition[0];
                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_G_2 = IN.ObjectSpacePosition[1];
                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_B_3 = IN.ObjectSpacePosition[2];
                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_A_4 = 0;
                                            float2 _Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0 = float2(_Split_781cad85a9f046a8980ed2a1d2d10664_R_1, _Split_781cad85a9f046a8980ed2a1d2d10664_B_3);
                                            float _Distance_767d57b101584aec91e1737df8c8189a_Out_2;
                                            Unity_Distance_float2(_Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0, float2(0, 0), _Distance_767d57b101584aec91e1737df8c8189a_Out_2);
                                            half _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0 = _NormalizeCoefficient;
                                            float _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2;
                                            Unity_Divide_float(_Distance_767d57b101584aec91e1737df8c8189a_Out_2, _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0, _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2);
                                            float _Split_0adf1cac2e75421a859d31b60cd64966_R_1 = IN.AbsoluteWorldSpacePosition[0];
                                            float _Split_0adf1cac2e75421a859d31b60cd64966_G_2 = IN.AbsoluteWorldSpacePosition[1];
                                            float _Split_0adf1cac2e75421a859d31b60cd64966_B_3 = IN.AbsoluteWorldSpacePosition[2];
                                            float _Split_0adf1cac2e75421a859d31b60cd64966_A_4 = 0;
                                            float2 _Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0 = float2(_Split_0adf1cac2e75421a859d31b60cd64966_R_1, _Split_0adf1cac2e75421a859d31b60cd64966_B_3);
                                            half _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0 = _NoiseScale;
                                            float _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2;
                                            Unity_GradientNoise_float(_Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0, _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2);
                                            float _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2;
                                            Unity_Add_float(_Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2);
                                            float _Step_737f617fc2ec402a993374a78d94cdff_Out_2;
                                            Unity_Step_float(_Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2, _Step_737f617fc2ec402a993374a78d94cdff_Out_2);
                                            float4 _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2;
                                            Unity_Multiply_float4_float4(_Property_ffa90d3b3f77485e984796da11d0ac19_Out_0, (_Step_737f617fc2ec402a993374a78d94cdff_Out_2.xxxx), _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2);
                                            float _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1;
                                            Unity_OneMinus_float(_Step_737f617fc2ec402a993374a78d94cdff_Out_2, _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1);
                                            half4 _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0 = _ReplaceableColor;
                                            float4 _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2;
                                            Unity_Multiply_float4_float4((_OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1.xxxx), _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2);
                                            float4 _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2;
                                            Unity_Add_float4(_Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2, _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2);
                                            surface.BaseColor = (_Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2.xyz);
                                            surface.Alpha = 1;
                                            surface.AlphaClipThreshold = 0.5;
                                            return surface;
                                        }

                                        // --------------------------------------------------
                                        // Build Graph Inputs
                                        #ifdef HAVE_VFX_MODIFICATION
                                        #define VFX_SRP_ATTRIBUTES Attributes
                                        #define VFX_SRP_VARYINGS Varyings
                                        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                        #endif
                                        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                        {
                                            VertexDescriptionInputs output;
                                            ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                            output.ObjectSpaceNormal = input.normalOS;
                                            output.ObjectSpaceTangent = input.tangentOS.xyz;
                                            output.ObjectSpacePosition = input.positionOS;

                                            return output;
                                        }
                                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                        {
                                            SurfaceDescriptionInputs output;
                                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                        #ifdef HAVE_VFX_MODIFICATION
                                            // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                        #endif







                                            output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
                                            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                        #else
                                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                        #endif
                                        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                return output;
                                        }

                                        // --------------------------------------------------
                                        // Main

                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

                                        // --------------------------------------------------
                                        // Visual Effect Vertex Invocations
                                        #ifdef HAVE_VFX_MODIFICATION
                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                        #endif

                                        ENDHLSL
                                        }
    }
        SubShader
                                        {
                                            Tags
                                            {
                                                "RenderPipeline" = "UniversalPipeline"
                                                "RenderType" = "Opaque"
                                                "UniversalMaterialType" = "Lit"
                                                "Queue" = "Geometry"
                                                "ShaderGraphShader" = "true"
                                                "ShaderGraphTargetId" = "UniversalLitSubTarget"
                                            }
                                            Pass
                                            {
                                                Name "Universal Forward"
                                                Tags
                                                {
                                                    "LightMode" = "UniversalForward"
                                                }

                                            // Render State
                                            Cull[_Cull]
                                            Blend[_SrcBlend][_DstBlend]
                                            ZTest[_ZTest]
                                            ZWrite[_ZWrite]

                                            // Debug
                                            // <None>

                                            // --------------------------------------------------
                                            // Pass

                                            HLSLPROGRAM

                                            // Pragmas
                                            #pragma target 2.0
                                            #pragma only_renderers gles gles3 glcore d3d11
                                            #pragma multi_compile_instancing
                                            #pragma multi_compile_fog
                                            #pragma instancing_options renderinglayer
                                            #pragma vertex vert
                                            #pragma fragment frag

                                            // DotsInstancingOptions: <None>
                                            // HybridV1InjectedBuiltinProperties: <None>

                                            // Keywords
                                            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
                                            #pragma multi_compile _ LIGHTMAP_ON
                                            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                                            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                                            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
                                            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
                                            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
                                            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
                                            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
                                            #pragma multi_compile_fragment _ _SHADOWS_SOFT
                                            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
                                            #pragma multi_compile _ SHADOWS_SHADOWMASK
                                            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
                                            #pragma multi_compile_fragment _ _LIGHT_LAYERS
                                            #pragma multi_compile_fragment _ DEBUG_DISPLAY
                                            #pragma multi_compile_fragment _ _LIGHT_COOKIES
                                            #pragma multi_compile _ _CLUSTERED_RENDERING
                                            #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
                                            #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
                                            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                            #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
                                            #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
                                            // GraphKeywords: <None>

                                            // Defines

                                            #define _NORMALMAP 1
                                            #define _NORMAL_DROPOFF_TS 1
                                            #define ATTRIBUTES_NEED_NORMAL
                                            #define ATTRIBUTES_NEED_TANGENT
                                            #define ATTRIBUTES_NEED_TEXCOORD1
                                            #define ATTRIBUTES_NEED_TEXCOORD2
                                            #define VARYINGS_NEED_POSITION_WS
                                            #define VARYINGS_NEED_NORMAL_WS
                                            #define VARYINGS_NEED_TANGENT_WS
                                            #define VARYINGS_NEED_VIEWDIRECTION_WS
                                            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                                            #define VARYINGS_NEED_SHADOW_COORD
                                            #define FEATURES_GRAPH_VERTEX
                                            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                            #define SHADERPASS SHADERPASS_FORWARD
                                            #define _FOG_FRAGMENT 1
                                            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                            // custom interpolator pre-include
                                            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                            // Includes
                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                            // --------------------------------------------------
                                            // Structs and Packing

                                            // custom interpolators pre packing
                                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                            struct Attributes
                                            {
                                                 float3 positionOS : POSITION;
                                                 float3 normalOS : NORMAL;
                                                 float4 tangentOS : TANGENT;
                                                 float4 uv1 : TEXCOORD1;
                                                 float4 uv2 : TEXCOORD2;
                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                 uint instanceID : INSTANCEID_SEMANTIC;
                                                #endif
                                            };
                                            struct Varyings
                                            {
                                                 float4 positionCS : SV_POSITION;
                                                 float3 positionWS;
                                                 float3 normalWS;
                                                 float4 tangentWS;
                                                 float3 viewDirectionWS;
                                                #if defined(LIGHTMAP_ON)
                                                 float2 staticLightmapUV;
                                                #endif
                                                #if defined(DYNAMICLIGHTMAP_ON)
                                                 float2 dynamicLightmapUV;
                                                #endif
                                                #if !defined(LIGHTMAP_ON)
                                                 float3 sh;
                                                #endif
                                                 float4 fogFactorAndVertexLight;
                                                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                                                 float4 shadowCoord;
                                                #endif
                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                 uint instanceID : CUSTOM_INSTANCE_ID;
                                                #endif
                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                #endif
                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                #endif
                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                #endif
                                            };
                                            struct SurfaceDescriptionInputs
                                            {
                                                 float3 TangentSpaceNormal;
                                                 float3 ObjectSpacePosition;
                                                 float3 AbsoluteWorldSpacePosition;
                                            };
                                            struct VertexDescriptionInputs
                                            {
                                                 float3 ObjectSpaceNormal;
                                                 float3 ObjectSpaceTangent;
                                                 float3 ObjectSpacePosition;
                                            };
                                            struct PackedVaryings
                                            {
                                                 float4 positionCS : SV_POSITION;
                                                 float3 interp0 : INTERP0;
                                                 float3 interp1 : INTERP1;
                                                 float4 interp2 : INTERP2;
                                                 float3 interp3 : INTERP3;
                                                 float2 interp4 : INTERP4;
                                                 float2 interp5 : INTERP5;
                                                 float3 interp6 : INTERP6;
                                                 float4 interp7 : INTERP7;
                                                 float4 interp8 : INTERP8;
                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                 uint instanceID : CUSTOM_INSTANCE_ID;
                                                #endif
                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                #endif
                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                #endif
                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                #endif
                                            };

                                            PackedVaryings PackVaryings(Varyings input)
                                            {
                                                PackedVaryings output;
                                                ZERO_INITIALIZE(PackedVaryings, output);
                                                output.positionCS = input.positionCS;
                                                output.interp0.xyz = input.positionWS;
                                                output.interp1.xyz = input.normalWS;
                                                output.interp2.xyzw = input.tangentWS;
                                                output.interp3.xyz = input.viewDirectionWS;
                                                #if defined(LIGHTMAP_ON)
                                                output.interp4.xy = input.staticLightmapUV;
                                                #endif
                                                #if defined(DYNAMICLIGHTMAP_ON)
                                                output.interp5.xy = input.dynamicLightmapUV;
                                                #endif
                                                #if !defined(LIGHTMAP_ON)
                                                output.interp6.xyz = input.sh;
                                                #endif
                                                output.interp7.xyzw = input.fogFactorAndVertexLight;
                                                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                                                output.interp8.xyzw = input.shadowCoord;
                                                #endif
                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                output.instanceID = input.instanceID;
                                                #endif
                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                #endif
                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                #endif
                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                output.cullFace = input.cullFace;
                                                #endif
                                                return output;
                                            }

                                            Varyings UnpackVaryings(PackedVaryings input)
                                            {
                                                Varyings output;
                                                output.positionCS = input.positionCS;
                                                output.positionWS = input.interp0.xyz;
                                                output.normalWS = input.interp1.xyz;
                                                output.tangentWS = input.interp2.xyzw;
                                                output.viewDirectionWS = input.interp3.xyz;
                                                #if defined(LIGHTMAP_ON)
                                                output.staticLightmapUV = input.interp4.xy;
                                                #endif
                                                #if defined(DYNAMICLIGHTMAP_ON)
                                                output.dynamicLightmapUV = input.interp5.xy;
                                                #endif
                                                #if !defined(LIGHTMAP_ON)
                                                output.sh = input.interp6.xyz;
                                                #endif
                                                output.fogFactorAndVertexLight = input.interp7.xyzw;
                                                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                                                output.shadowCoord = input.interp8.xyzw;
                                                #endif
                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                output.instanceID = input.instanceID;
                                                #endif
                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                #endif
                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                #endif
                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                output.cullFace = input.cullFace;
                                                #endif
                                                return output;
                                            }


                                            // --------------------------------------------------
                                            // Graph

                                            // Graph Properties
                                            CBUFFER_START(UnityPerMaterial)
                                            half _Edge;
                                            half4 _BaseColor;
                                            half4 _ReplaceableColor;
                                            half _NoiseScale;
                                            half _NormalizeCoefficient;
                                            half _Smoothness;
                                            half _Metallic;
                                            CBUFFER_END

                                                // Object and Global properties

                                                // Graph Includes
                                                // GraphIncludes: <None>

                                                // -- Property used by ScenePickingPass
                                                #ifdef SCENEPICKINGPASS
                                                float4 _SelectionID;
                                                #endif

                                            // -- Properties used by SceneSelectionPass
                                            #ifdef SCENESELECTIONPASS
                                            int _ObjectId;
                                            int _PassValue;
                                            #endif

                                            // Graph Functions

                                            void Unity_Distance_float2(float2 A, float2 B, out float Out)
                                            {
                                                Out = distance(A, B);
                                            }

                                            void Unity_Divide_float(float A, float B, out float Out)
                                            {
                                                Out = A / B;
                                            }


                                            float2 Unity_GradientNoise_Dir_float(float2 p)
                                            {
                                                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                                                p = p % 289;
                                                // need full precision, otherwise half overflows when p > 1
                                                float x = float(34 * p.x + 1) * p.x % 289 + p.y;
                                                x = (34 * x + 1) * x % 289;
                                                x = frac(x / 41) * 2 - 1;
                                                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                                            }

                                            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                                            {
                                                float2 p = UV * Scale;
                                                float2 ip = floor(p);
                                                float2 fp = frac(p);
                                                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                                                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                                            }

                                            void Unity_Add_float(float A, float B, out float Out)
                                            {
                                                Out = A + B;
                                            }

                                            void Unity_Step_float(float Edge, float In, out float Out)
                                            {
                                                Out = step(Edge, In);
                                            }

                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                            {
                                                Out = A * B;
                                            }

                                            void Unity_OneMinus_float(float In, out float Out)
                                            {
                                                Out = 1 - In;
                                            }

                                            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                                            {
                                                Out = A + B;
                                            }

                                            // Custom interpolators pre vertex
                                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                            // Graph Vertex
                                            struct VertexDescription
                                            {
                                                half3 Position;
                                                half3 Normal;
                                                half3 Tangent;
                                            };

                                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                            {
                                                VertexDescription description = (VertexDescription)0;
                                                description.Position = IN.ObjectSpacePosition;
                                                description.Normal = IN.ObjectSpaceNormal;
                                                description.Tangent = IN.ObjectSpaceTangent;
                                                return description;
                                            }

                                            // Custom interpolators, pre surface
                                            #ifdef FEATURES_GRAPH_VERTEX
                                            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                            {
                                            return output;
                                            }
                                            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                            #endif

                                            // Graph Pixel
                                            struct SurfaceDescription
                                            {
                                                float3 BaseColor;
                                                half3 NormalTS;
                                                half3 Emission;
                                                half Metallic;
                                                half3 Specular;
                                                half Smoothness;
                                                half Occlusion;
                                                half Alpha;
                                                half AlphaClipThreshold;
                                            };

                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                            {
                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                half4 _Property_ffa90d3b3f77485e984796da11d0ac19_Out_0 = _BaseColor;
                                                half _Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0 = _Edge;
                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_R_1 = IN.ObjectSpacePosition[0];
                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_G_2 = IN.ObjectSpacePosition[1];
                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_B_3 = IN.ObjectSpacePosition[2];
                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_A_4 = 0;
                                                float2 _Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0 = float2(_Split_781cad85a9f046a8980ed2a1d2d10664_R_1, _Split_781cad85a9f046a8980ed2a1d2d10664_B_3);
                                                float _Distance_767d57b101584aec91e1737df8c8189a_Out_2;
                                                Unity_Distance_float2(_Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0, float2(0, 0), _Distance_767d57b101584aec91e1737df8c8189a_Out_2);
                                                half _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0 = _NormalizeCoefficient;
                                                float _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2;
                                                Unity_Divide_float(_Distance_767d57b101584aec91e1737df8c8189a_Out_2, _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0, _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2);
                                                float _Split_0adf1cac2e75421a859d31b60cd64966_R_1 = IN.AbsoluteWorldSpacePosition[0];
                                                float _Split_0adf1cac2e75421a859d31b60cd64966_G_2 = IN.AbsoluteWorldSpacePosition[1];
                                                float _Split_0adf1cac2e75421a859d31b60cd64966_B_3 = IN.AbsoluteWorldSpacePosition[2];
                                                float _Split_0adf1cac2e75421a859d31b60cd64966_A_4 = 0;
                                                float2 _Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0 = float2(_Split_0adf1cac2e75421a859d31b60cd64966_R_1, _Split_0adf1cac2e75421a859d31b60cd64966_B_3);
                                                half _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0 = _NoiseScale;
                                                float _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2;
                                                Unity_GradientNoise_float(_Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0, _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2);
                                                float _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2;
                                                Unity_Add_float(_Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2);
                                                float _Step_737f617fc2ec402a993374a78d94cdff_Out_2;
                                                Unity_Step_float(_Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2, _Step_737f617fc2ec402a993374a78d94cdff_Out_2);
                                                float4 _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2;
                                                Unity_Multiply_float4_float4(_Property_ffa90d3b3f77485e984796da11d0ac19_Out_0, (_Step_737f617fc2ec402a993374a78d94cdff_Out_2.xxxx), _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2);
                                                float _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1;
                                                Unity_OneMinus_float(_Step_737f617fc2ec402a993374a78d94cdff_Out_2, _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1);
                                                half4 _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0 = _ReplaceableColor;
                                                float4 _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2;
                                                Unity_Multiply_float4_float4((_OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1.xxxx), _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2);
                                                float4 _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2;
                                                Unity_Add_float4(_Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2, _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2);
                                                half _Property_4c3a908b10dc4ef2ba3dc511150c28c8_Out_0 = _Metallic;
                                                half _Property_b3f728e4a7964f72b1738931df8788dc_Out_0 = _Smoothness;
                                                surface.BaseColor = (_Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2.xyz);
                                                surface.NormalTS = IN.TangentSpaceNormal;
                                                surface.Emission = half3(0, 0, 0);
                                                surface.Metallic = _Property_4c3a908b10dc4ef2ba3dc511150c28c8_Out_0;
                                                surface.Specular = IsGammaSpace() ? half3(0.5, 0.5, 0.5) : SRGBToLinear(half3(0.5, 0.5, 0.5));
                                                surface.Smoothness = _Property_b3f728e4a7964f72b1738931df8788dc_Out_0;
                                                surface.Occlusion = 1;
                                                surface.Alpha = 1;
                                                surface.AlphaClipThreshold = 0.5;
                                                return surface;
                                            }

                                            // --------------------------------------------------
                                            // Build Graph Inputs
                                            #ifdef HAVE_VFX_MODIFICATION
                                            #define VFX_SRP_ATTRIBUTES Attributes
                                            #define VFX_SRP_VARYINGS Varyings
                                            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                            #endif
                                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                            {
                                                VertexDescriptionInputs output;
                                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                output.ObjectSpaceNormal = input.normalOS;
                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                output.ObjectSpacePosition = input.positionOS;

                                                return output;
                                            }
                                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                            {
                                                SurfaceDescriptionInputs output;
                                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                            #ifdef HAVE_VFX_MODIFICATION
                                                // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                            #endif





                                                output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                                                output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
                                                output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                            #else
                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                            #endif
                                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                    return output;
                                            }

                                            // --------------------------------------------------
                                            // Main

                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

                                            // --------------------------------------------------
                                            // Visual Effect Vertex Invocations
                                            #ifdef HAVE_VFX_MODIFICATION
                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                            #endif

                                            ENDHLSL
                                            }
                                            Pass
                                            {
                                                Name "ShadowCaster"
                                                Tags
                                                {
                                                    "LightMode" = "ShadowCaster"
                                                }

                                                // Render State
                                                Cull[_Cull]
                                                ZTest LEqual
                                                ZWrite On
                                                ColorMask 0

                                                // Debug
                                                // <None>

                                                // --------------------------------------------------
                                                // Pass

                                                HLSLPROGRAM

                                                // Pragmas
                                                #pragma target 2.0
                                                #pragma only_renderers gles gles3 glcore d3d11
                                                #pragma multi_compile_instancing
                                                #pragma vertex vert
                                                #pragma fragment frag

                                                // DotsInstancingOptions: <None>
                                                // HybridV1InjectedBuiltinProperties: <None>

                                                // Keywords
                                                #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
                                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                // GraphKeywords: <None>

                                                // Defines

                                                #define _NORMALMAP 1
                                                #define _NORMAL_DROPOFF_TS 1
                                                #define ATTRIBUTES_NEED_NORMAL
                                                #define ATTRIBUTES_NEED_TANGENT
                                                #define VARYINGS_NEED_NORMAL_WS
                                                #define FEATURES_GRAPH_VERTEX
                                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                #define SHADERPASS SHADERPASS_SHADOWCASTER
                                                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                // custom interpolator pre-include
                                                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                // Includes
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                // --------------------------------------------------
                                                // Structs and Packing

                                                // custom interpolators pre packing
                                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                struct Attributes
                                                {
                                                     float3 positionOS : POSITION;
                                                     float3 normalOS : NORMAL;
                                                     float4 tangentOS : TANGENT;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                     uint instanceID : INSTANCEID_SEMANTIC;
                                                    #endif
                                                };
                                                struct Varyings
                                                {
                                                     float4 positionCS : SV_POSITION;
                                                     float3 normalWS;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                    #endif
                                                };
                                                struct SurfaceDescriptionInputs
                                                {
                                                };
                                                struct VertexDescriptionInputs
                                                {
                                                     float3 ObjectSpaceNormal;
                                                     float3 ObjectSpaceTangent;
                                                     float3 ObjectSpacePosition;
                                                };
                                                struct PackedVaryings
                                                {
                                                     float4 positionCS : SV_POSITION;
                                                     float3 interp0 : INTERP0;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                    #endif
                                                };

                                                PackedVaryings PackVaryings(Varyings input)
                                                {
                                                    PackedVaryings output;
                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                    output.positionCS = input.positionCS;
                                                    output.interp0.xyz = input.normalWS;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                    output.instanceID = input.instanceID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    output.cullFace = input.cullFace;
                                                    #endif
                                                    return output;
                                                }

                                                Varyings UnpackVaryings(PackedVaryings input)
                                                {
                                                    Varyings output;
                                                    output.positionCS = input.positionCS;
                                                    output.normalWS = input.interp0.xyz;
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                    output.instanceID = input.instanceID;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    output.cullFace = input.cullFace;
                                                    #endif
                                                    return output;
                                                }


                                                // --------------------------------------------------
                                                // Graph

                                                // Graph Properties
                                                CBUFFER_START(UnityPerMaterial)
                                                half _Edge;
                                                half4 _BaseColor;
                                                half4 _ReplaceableColor;
                                                half _NoiseScale;
                                                half _NormalizeCoefficient;
                                                half _Smoothness;
                                                half _Metallic;
                                                CBUFFER_END

                                                    // Object and Global properties

                                                    // Graph Includes
                                                    // GraphIncludes: <None>

                                                    // -- Property used by ScenePickingPass
                                                    #ifdef SCENEPICKINGPASS
                                                    float4 _SelectionID;
                                                    #endif

                                                // -- Properties used by SceneSelectionPass
                                                #ifdef SCENESELECTIONPASS
                                                int _ObjectId;
                                                int _PassValue;
                                                #endif

                                                // Graph Functions
                                                // GraphFunctions: <None>

                                                // Custom interpolators pre vertex
                                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                // Graph Vertex
                                                struct VertexDescription
                                                {
                                                    half3 Position;
                                                    half3 Normal;
                                                    half3 Tangent;
                                                };

                                                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                {
                                                    VertexDescription description = (VertexDescription)0;
                                                    description.Position = IN.ObjectSpacePosition;
                                                    description.Normal = IN.ObjectSpaceNormal;
                                                    description.Tangent = IN.ObjectSpaceTangent;
                                                    return description;
                                                }

                                                // Custom interpolators, pre surface
                                                #ifdef FEATURES_GRAPH_VERTEX
                                                Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                {
                                                return output;
                                                }
                                                #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                #endif

                                                // Graph Pixel
                                                struct SurfaceDescription
                                                {
                                                    half Alpha;
                                                    half AlphaClipThreshold;
                                                };

                                                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                {
                                                    SurfaceDescription surface = (SurfaceDescription)0;
                                                    surface.Alpha = 1;
                                                    surface.AlphaClipThreshold = 0.5;
                                                    return surface;
                                                }

                                                // --------------------------------------------------
                                                // Build Graph Inputs
                                                #ifdef HAVE_VFX_MODIFICATION
                                                #define VFX_SRP_ATTRIBUTES Attributes
                                                #define VFX_SRP_VARYINGS Varyings
                                                #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                #endif
                                                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                {
                                                    VertexDescriptionInputs output;
                                                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                    output.ObjectSpaceNormal = input.normalOS;
                                                    output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                    output.ObjectSpacePosition = input.positionOS;

                                                    return output;
                                                }
                                                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                {
                                                    SurfaceDescriptionInputs output;
                                                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                #ifdef HAVE_VFX_MODIFICATION
                                                    // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                #endif







                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                #else
                                                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                #endif
                                                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                        return output;
                                                }

                                                // --------------------------------------------------
                                                // Main

                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

                                                // --------------------------------------------------
                                                // Visual Effect Vertex Invocations
                                                #ifdef HAVE_VFX_MODIFICATION
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                #endif

                                                ENDHLSL
                                                }
                                                Pass
                                                {
                                                    Name "DepthOnly"
                                                    Tags
                                                    {
                                                        "LightMode" = "DepthOnly"
                                                    }

                                                    // Render State
                                                    Cull[_Cull]
                                                    ZTest LEqual
                                                    ZWrite On
                                                    ColorMask 0

                                                    // Debug
                                                    // <None>

                                                    // --------------------------------------------------
                                                    // Pass

                                                    HLSLPROGRAM

                                                    // Pragmas
                                                    #pragma target 2.0
                                                    #pragma only_renderers gles gles3 glcore d3d11
                                                    #pragma multi_compile_instancing
                                                    #pragma vertex vert
                                                    #pragma fragment frag

                                                    // DotsInstancingOptions: <None>
                                                    // HybridV1InjectedBuiltinProperties: <None>

                                                    // Keywords
                                                    #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                    // GraphKeywords: <None>

                                                    // Defines

                                                    #define _NORMALMAP 1
                                                    #define _NORMAL_DROPOFF_TS 1
                                                    #define ATTRIBUTES_NEED_NORMAL
                                                    #define ATTRIBUTES_NEED_TANGENT
                                                    #define FEATURES_GRAPH_VERTEX
                                                    /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                    #define SHADERPASS SHADERPASS_DEPTHONLY
                                                    /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                    // custom interpolator pre-include
                                                    /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                    // Includes
                                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                    // --------------------------------------------------
                                                    // Structs and Packing

                                                    // custom interpolators pre packing
                                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                    struct Attributes
                                                    {
                                                         float3 positionOS : POSITION;
                                                         float3 normalOS : NORMAL;
                                                         float4 tangentOS : TANGENT;
                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                         uint instanceID : INSTANCEID_SEMANTIC;
                                                        #endif
                                                    };
                                                    struct Varyings
                                                    {
                                                         float4 positionCS : SV_POSITION;
                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                         uint instanceID : CUSTOM_INSTANCE_ID;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                        #endif
                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                        #endif
                                                    };
                                                    struct SurfaceDescriptionInputs
                                                    {
                                                    };
                                                    struct VertexDescriptionInputs
                                                    {
                                                         float3 ObjectSpaceNormal;
                                                         float3 ObjectSpaceTangent;
                                                         float3 ObjectSpacePosition;
                                                    };
                                                    struct PackedVaryings
                                                    {
                                                         float4 positionCS : SV_POSITION;
                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                         uint instanceID : CUSTOM_INSTANCE_ID;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                        #endif
                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                        #endif
                                                    };

                                                    PackedVaryings PackVaryings(Varyings input)
                                                    {
                                                        PackedVaryings output;
                                                        ZERO_INITIALIZE(PackedVaryings, output);
                                                        output.positionCS = input.positionCS;
                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                        output.instanceID = input.instanceID;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                        #endif
                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                        output.cullFace = input.cullFace;
                                                        #endif
                                                        return output;
                                                    }

                                                    Varyings UnpackVaryings(PackedVaryings input)
                                                    {
                                                        Varyings output;
                                                        output.positionCS = input.positionCS;
                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                        output.instanceID = input.instanceID;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                        #endif
                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                        output.cullFace = input.cullFace;
                                                        #endif
                                                        return output;
                                                    }


                                                    // --------------------------------------------------
                                                    // Graph

                                                    // Graph Properties
                                                    CBUFFER_START(UnityPerMaterial)
                                                    half _Edge;
                                                    half4 _BaseColor;
                                                    half4 _ReplaceableColor;
                                                    half _NoiseScale;
                                                    half _NormalizeCoefficient;
                                                    half _Smoothness;
                                                    half _Metallic;
                                                    CBUFFER_END

                                                        // Object and Global properties

                                                        // Graph Includes
                                                        // GraphIncludes: <None>

                                                        // -- Property used by ScenePickingPass
                                                        #ifdef SCENEPICKINGPASS
                                                        float4 _SelectionID;
                                                        #endif

                                                    // -- Properties used by SceneSelectionPass
                                                    #ifdef SCENESELECTIONPASS
                                                    int _ObjectId;
                                                    int _PassValue;
                                                    #endif

                                                    // Graph Functions
                                                    // GraphFunctions: <None>

                                                    // Custom interpolators pre vertex
                                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                    // Graph Vertex
                                                    struct VertexDescription
                                                    {
                                                        half3 Position;
                                                        half3 Normal;
                                                        half3 Tangent;
                                                    };

                                                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                    {
                                                        VertexDescription description = (VertexDescription)0;
                                                        description.Position = IN.ObjectSpacePosition;
                                                        description.Normal = IN.ObjectSpaceNormal;
                                                        description.Tangent = IN.ObjectSpaceTangent;
                                                        return description;
                                                    }

                                                    // Custom interpolators, pre surface
                                                    #ifdef FEATURES_GRAPH_VERTEX
                                                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                    {
                                                    return output;
                                                    }
                                                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                    #endif

                                                    // Graph Pixel
                                                    struct SurfaceDescription
                                                    {
                                                        half Alpha;
                                                        half AlphaClipThreshold;
                                                    };

                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                    {
                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                        surface.Alpha = 1;
                                                        surface.AlphaClipThreshold = 0.5;
                                                        return surface;
                                                    }

                                                    // --------------------------------------------------
                                                    // Build Graph Inputs
                                                    #ifdef HAVE_VFX_MODIFICATION
                                                    #define VFX_SRP_ATTRIBUTES Attributes
                                                    #define VFX_SRP_VARYINGS Varyings
                                                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                    #endif
                                                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                    {
                                                        VertexDescriptionInputs output;
                                                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                        output.ObjectSpaceNormal = input.normalOS;
                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                        output.ObjectSpacePosition = input.positionOS;

                                                        return output;
                                                    }
                                                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                    {
                                                        SurfaceDescriptionInputs output;
                                                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                    #ifdef HAVE_VFX_MODIFICATION
                                                        // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                    #endif







                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                    #else
                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                    #endif
                                                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                            return output;
                                                    }

                                                    // --------------------------------------------------
                                                    // Main

                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

                                                    // --------------------------------------------------
                                                    // Visual Effect Vertex Invocations
                                                    #ifdef HAVE_VFX_MODIFICATION
                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                    #endif

                                                    ENDHLSL
                                                    }
                                                    Pass
                                                    {
                                                        Name "DepthNormals"
                                                        Tags
                                                        {
                                                            "LightMode" = "DepthNormals"
                                                        }

                                                        // Render State
                                                        Cull[_Cull]
                                                        ZTest LEqual
                                                        ZWrite On

                                                        // Debug
                                                        // <None>

                                                        // --------------------------------------------------
                                                        // Pass

                                                        HLSLPROGRAM

                                                        // Pragmas
                                                        #pragma target 2.0
                                                        #pragma only_renderers gles gles3 glcore d3d11
                                                        #pragma multi_compile_instancing
                                                        #pragma vertex vert
                                                        #pragma fragment frag

                                                        // DotsInstancingOptions: <None>
                                                        // HybridV1InjectedBuiltinProperties: <None>

                                                        // Keywords
                                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                        // GraphKeywords: <None>

                                                        // Defines

                                                        #define _NORMALMAP 1
                                                        #define _NORMAL_DROPOFF_TS 1
                                                        #define ATTRIBUTES_NEED_NORMAL
                                                        #define ATTRIBUTES_NEED_TANGENT
                                                        #define ATTRIBUTES_NEED_TEXCOORD1
                                                        #define VARYINGS_NEED_NORMAL_WS
                                                        #define VARYINGS_NEED_TANGENT_WS
                                                        #define FEATURES_GRAPH_VERTEX
                                                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                        #define SHADERPASS SHADERPASS_DEPTHNORMALS
                                                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                        // custom interpolator pre-include
                                                        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                        // Includes
                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                        // --------------------------------------------------
                                                        // Structs and Packing

                                                        // custom interpolators pre packing
                                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                        struct Attributes
                                                        {
                                                             float3 positionOS : POSITION;
                                                             float3 normalOS : NORMAL;
                                                             float4 tangentOS : TANGENT;
                                                             float4 uv1 : TEXCOORD1;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                             uint instanceID : INSTANCEID_SEMANTIC;
                                                            #endif
                                                        };
                                                        struct Varyings
                                                        {
                                                             float4 positionCS : SV_POSITION;
                                                             float3 normalWS;
                                                             float4 tangentWS;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                            #endif
                                                        };
                                                        struct SurfaceDescriptionInputs
                                                        {
                                                             float3 TangentSpaceNormal;
                                                        };
                                                        struct VertexDescriptionInputs
                                                        {
                                                             float3 ObjectSpaceNormal;
                                                             float3 ObjectSpaceTangent;
                                                             float3 ObjectSpacePosition;
                                                        };
                                                        struct PackedVaryings
                                                        {
                                                             float4 positionCS : SV_POSITION;
                                                             float3 interp0 : INTERP0;
                                                             float4 interp1 : INTERP1;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                            #endif
                                                        };

                                                        PackedVaryings PackVaryings(Varyings input)
                                                        {
                                                            PackedVaryings output;
                                                            ZERO_INITIALIZE(PackedVaryings, output);
                                                            output.positionCS = input.positionCS;
                                                            output.interp0.xyz = input.normalWS;
                                                            output.interp1.xyzw = input.tangentWS;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                            output.instanceID = input.instanceID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                            output.cullFace = input.cullFace;
                                                            #endif
                                                            return output;
                                                        }

                                                        Varyings UnpackVaryings(PackedVaryings input)
                                                        {
                                                            Varyings output;
                                                            output.positionCS = input.positionCS;
                                                            output.normalWS = input.interp0.xyz;
                                                            output.tangentWS = input.interp1.xyzw;
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                            output.instanceID = input.instanceID;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                            #endif
                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                            #endif
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                            output.cullFace = input.cullFace;
                                                            #endif
                                                            return output;
                                                        }


                                                        // --------------------------------------------------
                                                        // Graph

                                                        // Graph Properties
                                                        CBUFFER_START(UnityPerMaterial)
                                                        half _Edge;
                                                        half4 _BaseColor;
                                                        half4 _ReplaceableColor;
                                                        half _NoiseScale;
                                                        half _NormalizeCoefficient;
                                                        half _Smoothness;
                                                        half _Metallic;
                                                        CBUFFER_END

                                                            // Object and Global properties

                                                            // Graph Includes
                                                            // GraphIncludes: <None>

                                                            // -- Property used by ScenePickingPass
                                                            #ifdef SCENEPICKINGPASS
                                                            float4 _SelectionID;
                                                            #endif

                                                        // -- Properties used by SceneSelectionPass
                                                        #ifdef SCENESELECTIONPASS
                                                        int _ObjectId;
                                                        int _PassValue;
                                                        #endif

                                                        // Graph Functions
                                                        // GraphFunctions: <None>

                                                        // Custom interpolators pre vertex
                                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                        // Graph Vertex
                                                        struct VertexDescription
                                                        {
                                                            half3 Position;
                                                            half3 Normal;
                                                            half3 Tangent;
                                                        };

                                                        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                        {
                                                            VertexDescription description = (VertexDescription)0;
                                                            description.Position = IN.ObjectSpacePosition;
                                                            description.Normal = IN.ObjectSpaceNormal;
                                                            description.Tangent = IN.ObjectSpaceTangent;
                                                            return description;
                                                        }

                                                        // Custom interpolators, pre surface
                                                        #ifdef FEATURES_GRAPH_VERTEX
                                                        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                        {
                                                        return output;
                                                        }
                                                        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                        #endif

                                                        // Graph Pixel
                                                        struct SurfaceDescription
                                                        {
                                                            half3 NormalTS;
                                                            half Alpha;
                                                            half AlphaClipThreshold;
                                                        };

                                                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                        {
                                                            SurfaceDescription surface = (SurfaceDescription)0;
                                                            surface.NormalTS = IN.TangentSpaceNormal;
                                                            surface.Alpha = 1;
                                                            surface.AlphaClipThreshold = 0.5;
                                                            return surface;
                                                        }

                                                        // --------------------------------------------------
                                                        // Build Graph Inputs
                                                        #ifdef HAVE_VFX_MODIFICATION
                                                        #define VFX_SRP_ATTRIBUTES Attributes
                                                        #define VFX_SRP_VARYINGS Varyings
                                                        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                        #endif
                                                        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                        {
                                                            VertexDescriptionInputs output;
                                                            ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                            output.ObjectSpaceNormal = input.normalOS;
                                                            output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                            output.ObjectSpacePosition = input.positionOS;

                                                            return output;
                                                        }
                                                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                        {
                                                            SurfaceDescriptionInputs output;
                                                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                        #ifdef HAVE_VFX_MODIFICATION
                                                            // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                        #endif





                                                            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                        #else
                                                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                        #endif
                                                        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                                return output;
                                                        }

                                                        // --------------------------------------------------
                                                        // Main

                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

                                                        // --------------------------------------------------
                                                        // Visual Effect Vertex Invocations
                                                        #ifdef HAVE_VFX_MODIFICATION
                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                        #endif

                                                        ENDHLSL
                                                        }
                                                        Pass
                                                        {
                                                            Name "Meta"
                                                            Tags
                                                            {
                                                                "LightMode" = "Meta"
                                                            }

                                                            // Render State
                                                            Cull Off

                                                            // Debug
                                                            // <None>

                                                            // --------------------------------------------------
                                                            // Pass

                                                            HLSLPROGRAM

                                                            // Pragmas
                                                            #pragma target 2.0
                                                            #pragma only_renderers gles gles3 glcore d3d11
                                                            #pragma vertex vert
                                                            #pragma fragment frag

                                                            // DotsInstancingOptions: <None>
                                                            // HybridV1InjectedBuiltinProperties: <None>

                                                            // Keywords
                                                            #pragma shader_feature _ EDITOR_VISUALIZATION
                                                            #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                            // GraphKeywords: <None>

                                                            // Defines

                                                            #define _NORMALMAP 1
                                                            #define _NORMAL_DROPOFF_TS 1
                                                            #define ATTRIBUTES_NEED_NORMAL
                                                            #define ATTRIBUTES_NEED_TANGENT
                                                            #define ATTRIBUTES_NEED_TEXCOORD0
                                                            #define ATTRIBUTES_NEED_TEXCOORD1
                                                            #define ATTRIBUTES_NEED_TEXCOORD2
                                                            #define VARYINGS_NEED_POSITION_WS
                                                            #define VARYINGS_NEED_TEXCOORD0
                                                            #define VARYINGS_NEED_TEXCOORD1
                                                            #define VARYINGS_NEED_TEXCOORD2
                                                            #define FEATURES_GRAPH_VERTEX
                                                            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                            #define SHADERPASS SHADERPASS_META
                                                            #define _FOG_FRAGMENT 1
                                                            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                            // custom interpolator pre-include
                                                            /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                            // Includes
                                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                            // --------------------------------------------------
                                                            // Structs and Packing

                                                            // custom interpolators pre packing
                                                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                            struct Attributes
                                                            {
                                                                 float3 positionOS : POSITION;
                                                                 float3 normalOS : NORMAL;
                                                                 float4 tangentOS : TANGENT;
                                                                 float4 uv0 : TEXCOORD0;
                                                                 float4 uv1 : TEXCOORD1;
                                                                 float4 uv2 : TEXCOORD2;
                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                 uint instanceID : INSTANCEID_SEMANTIC;
                                                                #endif
                                                            };
                                                            struct Varyings
                                                            {
                                                                 float4 positionCS : SV_POSITION;
                                                                 float3 positionWS;
                                                                 float4 texCoord0;
                                                                 float4 texCoord1;
                                                                 float4 texCoord2;
                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                 uint instanceID : CUSTOM_INSTANCE_ID;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                #endif
                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                #endif
                                                            };
                                                            struct SurfaceDescriptionInputs
                                                            {
                                                                 float3 ObjectSpacePosition;
                                                                 float3 AbsoluteWorldSpacePosition;
                                                            };
                                                            struct VertexDescriptionInputs
                                                            {
                                                                 float3 ObjectSpaceNormal;
                                                                 float3 ObjectSpaceTangent;
                                                                 float3 ObjectSpacePosition;
                                                            };
                                                            struct PackedVaryings
                                                            {
                                                                 float4 positionCS : SV_POSITION;
                                                                 float3 interp0 : INTERP0;
                                                                 float4 interp1 : INTERP1;
                                                                 float4 interp2 : INTERP2;
                                                                 float4 interp3 : INTERP3;
                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                 uint instanceID : CUSTOM_INSTANCE_ID;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                #endif
                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                #endif
                                                            };

                                                            PackedVaryings PackVaryings(Varyings input)
                                                            {
                                                                PackedVaryings output;
                                                                ZERO_INITIALIZE(PackedVaryings, output);
                                                                output.positionCS = input.positionCS;
                                                                output.interp0.xyz = input.positionWS;
                                                                output.interp1.xyzw = input.texCoord0;
                                                                output.interp2.xyzw = input.texCoord1;
                                                                output.interp3.xyzw = input.texCoord2;
                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                output.instanceID = input.instanceID;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                #endif
                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                output.cullFace = input.cullFace;
                                                                #endif
                                                                return output;
                                                            }

                                                            Varyings UnpackVaryings(PackedVaryings input)
                                                            {
                                                                Varyings output;
                                                                output.positionCS = input.positionCS;
                                                                output.positionWS = input.interp0.xyz;
                                                                output.texCoord0 = input.interp1.xyzw;
                                                                output.texCoord1 = input.interp2.xyzw;
                                                                output.texCoord2 = input.interp3.xyzw;
                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                output.instanceID = input.instanceID;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                #endif
                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                #endif
                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                output.cullFace = input.cullFace;
                                                                #endif
                                                                return output;
                                                            }


                                                            // --------------------------------------------------
                                                            // Graph

                                                            // Graph Properties
                                                            CBUFFER_START(UnityPerMaterial)
                                                            half _Edge;
                                                            half4 _BaseColor;
                                                            half4 _ReplaceableColor;
                                                            half _NoiseScale;
                                                            half _NormalizeCoefficient;
                                                            half _Smoothness;
                                                            half _Metallic;
                                                            CBUFFER_END

                                                                // Object and Global properties

                                                                // Graph Includes
                                                                // GraphIncludes: <None>

                                                                // -- Property used by ScenePickingPass
                                                                #ifdef SCENEPICKINGPASS
                                                                float4 _SelectionID;
                                                                #endif

                                                            // -- Properties used by SceneSelectionPass
                                                            #ifdef SCENESELECTIONPASS
                                                            int _ObjectId;
                                                            int _PassValue;
                                                            #endif

                                                            // Graph Functions

                                                            void Unity_Distance_float2(float2 A, float2 B, out float Out)
                                                            {
                                                                Out = distance(A, B);
                                                            }

                                                            void Unity_Divide_float(float A, float B, out float Out)
                                                            {
                                                                Out = A / B;
                                                            }


                                                            float2 Unity_GradientNoise_Dir_float(float2 p)
                                                            {
                                                                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                                                                p = p % 289;
                                                                // need full precision, otherwise half overflows when p > 1
                                                                float x = float(34 * p.x + 1) * p.x % 289 + p.y;
                                                                x = (34 * x + 1) * x % 289;
                                                                x = frac(x / 41) * 2 - 1;
                                                                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                                                            }

                                                            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                                                            {
                                                                float2 p = UV * Scale;
                                                                float2 ip = floor(p);
                                                                float2 fp = frac(p);
                                                                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                                                                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                                                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                                                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                                                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                                                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                                                            }

                                                            void Unity_Add_float(float A, float B, out float Out)
                                                            {
                                                                Out = A + B;
                                                            }

                                                            void Unity_Step_float(float Edge, float In, out float Out)
                                                            {
                                                                Out = step(Edge, In);
                                                            }

                                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                            {
                                                                Out = A * B;
                                                            }

                                                            void Unity_OneMinus_float(float In, out float Out)
                                                            {
                                                                Out = 1 - In;
                                                            }

                                                            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                                                            {
                                                                Out = A + B;
                                                            }

                                                            // Custom interpolators pre vertex
                                                            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                            // Graph Vertex
                                                            struct VertexDescription
                                                            {
                                                                half3 Position;
                                                                half3 Normal;
                                                                half3 Tangent;
                                                            };

                                                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                            {
                                                                VertexDescription description = (VertexDescription)0;
                                                                description.Position = IN.ObjectSpacePosition;
                                                                description.Normal = IN.ObjectSpaceNormal;
                                                                description.Tangent = IN.ObjectSpaceTangent;
                                                                return description;
                                                            }

                                                            // Custom interpolators, pre surface
                                                            #ifdef FEATURES_GRAPH_VERTEX
                                                            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                            {
                                                            return output;
                                                            }
                                                            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                            #endif

                                                            // Graph Pixel
                                                            struct SurfaceDescription
                                                            {
                                                                float3 BaseColor;
                                                                half3 Emission;
                                                                half Alpha;
                                                                half AlphaClipThreshold;
                                                            };

                                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                            {
                                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                                half4 _Property_ffa90d3b3f77485e984796da11d0ac19_Out_0 = _BaseColor;
                                                                half _Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0 = _Edge;
                                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_R_1 = IN.ObjectSpacePosition[0];
                                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_G_2 = IN.ObjectSpacePosition[1];
                                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_B_3 = IN.ObjectSpacePosition[2];
                                                                float _Split_781cad85a9f046a8980ed2a1d2d10664_A_4 = 0;
                                                                float2 _Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0 = float2(_Split_781cad85a9f046a8980ed2a1d2d10664_R_1, _Split_781cad85a9f046a8980ed2a1d2d10664_B_3);
                                                                float _Distance_767d57b101584aec91e1737df8c8189a_Out_2;
                                                                Unity_Distance_float2(_Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0, float2(0, 0), _Distance_767d57b101584aec91e1737df8c8189a_Out_2);
                                                                half _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0 = _NormalizeCoefficient;
                                                                float _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2;
                                                                Unity_Divide_float(_Distance_767d57b101584aec91e1737df8c8189a_Out_2, _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0, _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2);
                                                                float _Split_0adf1cac2e75421a859d31b60cd64966_R_1 = IN.AbsoluteWorldSpacePosition[0];
                                                                float _Split_0adf1cac2e75421a859d31b60cd64966_G_2 = IN.AbsoluteWorldSpacePosition[1];
                                                                float _Split_0adf1cac2e75421a859d31b60cd64966_B_3 = IN.AbsoluteWorldSpacePosition[2];
                                                                float _Split_0adf1cac2e75421a859d31b60cd64966_A_4 = 0;
                                                                float2 _Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0 = float2(_Split_0adf1cac2e75421a859d31b60cd64966_R_1, _Split_0adf1cac2e75421a859d31b60cd64966_B_3);
                                                                half _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0 = _NoiseScale;
                                                                float _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2;
                                                                Unity_GradientNoise_float(_Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0, _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2);
                                                                float _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2;
                                                                Unity_Add_float(_Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2);
                                                                float _Step_737f617fc2ec402a993374a78d94cdff_Out_2;
                                                                Unity_Step_float(_Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2, _Step_737f617fc2ec402a993374a78d94cdff_Out_2);
                                                                float4 _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2;
                                                                Unity_Multiply_float4_float4(_Property_ffa90d3b3f77485e984796da11d0ac19_Out_0, (_Step_737f617fc2ec402a993374a78d94cdff_Out_2.xxxx), _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2);
                                                                float _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1;
                                                                Unity_OneMinus_float(_Step_737f617fc2ec402a993374a78d94cdff_Out_2, _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1);
                                                                half4 _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0 = _ReplaceableColor;
                                                                float4 _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2;
                                                                Unity_Multiply_float4_float4((_OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1.xxxx), _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2);
                                                                float4 _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2;
                                                                Unity_Add_float4(_Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2, _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2);
                                                                surface.BaseColor = (_Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2.xyz);
                                                                surface.Emission = half3(0, 0, 0);
                                                                surface.Alpha = 1;
                                                                surface.AlphaClipThreshold = 0.5;
                                                                return surface;
                                                            }

                                                            // --------------------------------------------------
                                                            // Build Graph Inputs
                                                            #ifdef HAVE_VFX_MODIFICATION
                                                            #define VFX_SRP_ATTRIBUTES Attributes
                                                            #define VFX_SRP_VARYINGS Varyings
                                                            #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                            #endif
                                                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                            {
                                                                VertexDescriptionInputs output;
                                                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                output.ObjectSpaceNormal = input.normalOS;
                                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                output.ObjectSpacePosition = input.positionOS;

                                                                return output;
                                                            }
                                                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                            {
                                                                SurfaceDescriptionInputs output;
                                                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                            #ifdef HAVE_VFX_MODIFICATION
                                                                // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                                /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                            #endif







                                                                output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
                                                                output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                            #else
                                                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                            #endif
                                                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                                    return output;
                                                            }

                                                            // --------------------------------------------------
                                                            // Main

                                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

                                                            // --------------------------------------------------
                                                            // Visual Effect Vertex Invocations
                                                            #ifdef HAVE_VFX_MODIFICATION
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                            #endif

                                                            ENDHLSL
                                                            }
                                                            Pass
                                                            {
                                                                Name "SceneSelectionPass"
                                                                Tags
                                                                {
                                                                    "LightMode" = "SceneSelectionPass"
                                                                }

                                                                // Render State
                                                                Cull Off

                                                                // Debug
                                                                // <None>

                                                                // --------------------------------------------------
                                                                // Pass

                                                                HLSLPROGRAM

                                                                // Pragmas
                                                                #pragma target 2.0
                                                                #pragma only_renderers gles gles3 glcore d3d11
                                                                #pragma multi_compile_instancing
                                                                #pragma vertex vert
                                                                #pragma fragment frag

                                                                // DotsInstancingOptions: <None>
                                                                // HybridV1InjectedBuiltinProperties: <None>

                                                                // Keywords
                                                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                // GraphKeywords: <None>

                                                                // Defines

                                                                #define _NORMALMAP 1
                                                                #define _NORMAL_DROPOFF_TS 1
                                                                #define ATTRIBUTES_NEED_NORMAL
                                                                #define ATTRIBUTES_NEED_TANGENT
                                                                #define FEATURES_GRAPH_VERTEX
                                                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                                #define SHADERPASS SHADERPASS_DEPTHONLY
                                                                #define SCENESELECTIONPASS 1
                                                                #define ALPHA_CLIP_THRESHOLD 1
                                                                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                                // custom interpolator pre-include
                                                                /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                                // Includes
                                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                                // --------------------------------------------------
                                                                // Structs and Packing

                                                                // custom interpolators pre packing
                                                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                                struct Attributes
                                                                {
                                                                     float3 positionOS : POSITION;
                                                                     float3 normalOS : NORMAL;
                                                                     float4 tangentOS : TANGENT;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                     uint instanceID : INSTANCEID_SEMANTIC;
                                                                    #endif
                                                                };
                                                                struct Varyings
                                                                {
                                                                     float4 positionCS : SV_POSITION;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                    #endif
                                                                };
                                                                struct SurfaceDescriptionInputs
                                                                {
                                                                };
                                                                struct VertexDescriptionInputs
                                                                {
                                                                     float3 ObjectSpaceNormal;
                                                                     float3 ObjectSpaceTangent;
                                                                     float3 ObjectSpacePosition;
                                                                };
                                                                struct PackedVaryings
                                                                {
                                                                     float4 positionCS : SV_POSITION;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                     uint instanceID : CUSTOM_INSTANCE_ID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                    #endif
                                                                };

                                                                PackedVaryings PackVaryings(Varyings input)
                                                                {
                                                                    PackedVaryings output;
                                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                                    output.positionCS = input.positionCS;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                    output.instanceID = input.instanceID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    output.cullFace = input.cullFace;
                                                                    #endif
                                                                    return output;
                                                                }

                                                                Varyings UnpackVaryings(PackedVaryings input)
                                                                {
                                                                    Varyings output;
                                                                    output.positionCS = input.positionCS;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                    output.instanceID = input.instanceID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    output.cullFace = input.cullFace;
                                                                    #endif
                                                                    return output;
                                                                }


                                                                // --------------------------------------------------
                                                                // Graph

                                                                // Graph Properties
                                                                CBUFFER_START(UnityPerMaterial)
                                                                half _Edge;
                                                                half4 _BaseColor;
                                                                half4 _ReplaceableColor;
                                                                half _NoiseScale;
                                                                half _NormalizeCoefficient;
                                                                half _Smoothness;
                                                                half _Metallic;
                                                                CBUFFER_END

                                                                    // Object and Global properties

                                                                    // Graph Includes
                                                                    // GraphIncludes: <None>

                                                                    // -- Property used by ScenePickingPass
                                                                    #ifdef SCENEPICKINGPASS
                                                                    float4 _SelectionID;
                                                                    #endif

                                                                // -- Properties used by SceneSelectionPass
                                                                #ifdef SCENESELECTIONPASS
                                                                int _ObjectId;
                                                                int _PassValue;
                                                                #endif

                                                                // Graph Functions
                                                                // GraphFunctions: <None>

                                                                // Custom interpolators pre vertex
                                                                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                                // Graph Vertex
                                                                struct VertexDescription
                                                                {
                                                                    half3 Position;
                                                                    half3 Normal;
                                                                    half3 Tangent;
                                                                };

                                                                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                                {
                                                                    VertexDescription description = (VertexDescription)0;
                                                                    description.Position = IN.ObjectSpacePosition;
                                                                    description.Normal = IN.ObjectSpaceNormal;
                                                                    description.Tangent = IN.ObjectSpaceTangent;
                                                                    return description;
                                                                }

                                                                // Custom interpolators, pre surface
                                                                #ifdef FEATURES_GRAPH_VERTEX
                                                                Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                                {
                                                                return output;
                                                                }
                                                                #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                                #endif

                                                                // Graph Pixel
                                                                struct SurfaceDescription
                                                                {
                                                                    half Alpha;
                                                                    half AlphaClipThreshold;
                                                                };

                                                                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                {
                                                                    SurfaceDescription surface = (SurfaceDescription)0;
                                                                    surface.Alpha = 1;
                                                                    surface.AlphaClipThreshold = 0.5;
                                                                    return surface;
                                                                }

                                                                // --------------------------------------------------
                                                                // Build Graph Inputs
                                                                #ifdef HAVE_VFX_MODIFICATION
                                                                #define VFX_SRP_ATTRIBUTES Attributes
                                                                #define VFX_SRP_VARYINGS Varyings
                                                                #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                                #endif
                                                                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                                {
                                                                    VertexDescriptionInputs output;
                                                                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                    output.ObjectSpaceNormal = input.normalOS;
                                                                    output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                    output.ObjectSpacePosition = input.positionOS;

                                                                    return output;
                                                                }
                                                                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                                {
                                                                    SurfaceDescriptionInputs output;
                                                                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                                #ifdef HAVE_VFX_MODIFICATION
                                                                    // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                                    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                                #endif







                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                                #else
                                                                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                                #endif
                                                                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                                        return output;
                                                                }

                                                                // --------------------------------------------------
                                                                // Main

                                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

                                                                // --------------------------------------------------
                                                                // Visual Effect Vertex Invocations
                                                                #ifdef HAVE_VFX_MODIFICATION
                                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                                #endif

                                                                ENDHLSL
                                                                }
                                                                Pass
                                                                {
                                                                    Name "ScenePickingPass"
                                                                    Tags
                                                                    {
                                                                        "LightMode" = "Picking"
                                                                    }

                                                                    // Render State
                                                                    Cull[_Cull]

                                                                    // Debug
                                                                    // <None>

                                                                    // --------------------------------------------------
                                                                    // Pass

                                                                    HLSLPROGRAM

                                                                    // Pragmas
                                                                    #pragma target 2.0
                                                                    #pragma only_renderers gles gles3 glcore d3d11
                                                                    #pragma multi_compile_instancing
                                                                    #pragma vertex vert
                                                                    #pragma fragment frag

                                                                    // DotsInstancingOptions: <None>
                                                                    // HybridV1InjectedBuiltinProperties: <None>

                                                                    // Keywords
                                                                    #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                    // GraphKeywords: <None>

                                                                    // Defines

                                                                    #define _NORMALMAP 1
                                                                    #define _NORMAL_DROPOFF_TS 1
                                                                    #define ATTRIBUTES_NEED_NORMAL
                                                                    #define ATTRIBUTES_NEED_TANGENT
                                                                    #define FEATURES_GRAPH_VERTEX
                                                                    /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                                    #define SHADERPASS SHADERPASS_DEPTHONLY
                                                                    #define SCENEPICKINGPASS 1
                                                                    #define ALPHA_CLIP_THRESHOLD 1
                                                                    /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                                    // custom interpolator pre-include
                                                                    /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                                    // Includes
                                                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                                    // --------------------------------------------------
                                                                    // Structs and Packing

                                                                    // custom interpolators pre packing
                                                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                                    struct Attributes
                                                                    {
                                                                         float3 positionOS : POSITION;
                                                                         float3 normalOS : NORMAL;
                                                                         float4 tangentOS : TANGENT;
                                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                                         uint instanceID : INSTANCEID_SEMANTIC;
                                                                        #endif
                                                                    };
                                                                    struct Varyings
                                                                    {
                                                                         float4 positionCS : SV_POSITION;
                                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                                         uint instanceID : CUSTOM_INSTANCE_ID;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                        #endif
                                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                        #endif
                                                                    };
                                                                    struct SurfaceDescriptionInputs
                                                                    {
                                                                    };
                                                                    struct VertexDescriptionInputs
                                                                    {
                                                                         float3 ObjectSpaceNormal;
                                                                         float3 ObjectSpaceTangent;
                                                                         float3 ObjectSpacePosition;
                                                                    };
                                                                    struct PackedVaryings
                                                                    {
                                                                         float4 positionCS : SV_POSITION;
                                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                                         uint instanceID : CUSTOM_INSTANCE_ID;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                         uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                         uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                        #endif
                                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                         FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                        #endif
                                                                    };

                                                                    PackedVaryings PackVaryings(Varyings input)
                                                                    {
                                                                        PackedVaryings output;
                                                                        ZERO_INITIALIZE(PackedVaryings, output);
                                                                        output.positionCS = input.positionCS;
                                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                                        output.instanceID = input.instanceID;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                        #endif
                                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                        output.cullFace = input.cullFace;
                                                                        #endif
                                                                        return output;
                                                                    }

                                                                    Varyings UnpackVaryings(PackedVaryings input)
                                                                    {
                                                                        Varyings output;
                                                                        output.positionCS = input.positionCS;
                                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                                        output.instanceID = input.instanceID;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                        #endif
                                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                        #endif
                                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                        output.cullFace = input.cullFace;
                                                                        #endif
                                                                        return output;
                                                                    }


                                                                    // --------------------------------------------------
                                                                    // Graph

                                                                    // Graph Properties
                                                                    CBUFFER_START(UnityPerMaterial)
                                                                    half _Edge;
                                                                    half4 _BaseColor;
                                                                    half4 _ReplaceableColor;
                                                                    half _NoiseScale;
                                                                    half _NormalizeCoefficient;
                                                                    half _Smoothness;
                                                                    half _Metallic;
                                                                    CBUFFER_END

                                                                        // Object and Global properties

                                                                        // Graph Includes
                                                                        // GraphIncludes: <None>

                                                                        // -- Property used by ScenePickingPass
                                                                        #ifdef SCENEPICKINGPASS
                                                                        float4 _SelectionID;
                                                                        #endif

                                                                    // -- Properties used by SceneSelectionPass
                                                                    #ifdef SCENESELECTIONPASS
                                                                    int _ObjectId;
                                                                    int _PassValue;
                                                                    #endif

                                                                    // Graph Functions
                                                                    // GraphFunctions: <None>

                                                                    // Custom interpolators pre vertex
                                                                    /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                                    // Graph Vertex
                                                                    struct VertexDescription
                                                                    {
                                                                        half3 Position;
                                                                        half3 Normal;
                                                                        half3 Tangent;
                                                                    };

                                                                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                                    {
                                                                        VertexDescription description = (VertexDescription)0;
                                                                        description.Position = IN.ObjectSpacePosition;
                                                                        description.Normal = IN.ObjectSpaceNormal;
                                                                        description.Tangent = IN.ObjectSpaceTangent;
                                                                        return description;
                                                                    }

                                                                    // Custom interpolators, pre surface
                                                                    #ifdef FEATURES_GRAPH_VERTEX
                                                                    Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                                    {
                                                                    return output;
                                                                    }
                                                                    #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                                    #endif

                                                                    // Graph Pixel
                                                                    struct SurfaceDescription
                                                                    {
                                                                        half Alpha;
                                                                        half AlphaClipThreshold;
                                                                    };

                                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                    {
                                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                                        surface.Alpha = 1;
                                                                        surface.AlphaClipThreshold = 0.5;
                                                                        return surface;
                                                                    }

                                                                    // --------------------------------------------------
                                                                    // Build Graph Inputs
                                                                    #ifdef HAVE_VFX_MODIFICATION
                                                                    #define VFX_SRP_ATTRIBUTES Attributes
                                                                    #define VFX_SRP_VARYINGS Varyings
                                                                    #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                                    #endif
                                                                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                                    {
                                                                        VertexDescriptionInputs output;
                                                                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                        output.ObjectSpaceNormal = input.normalOS;
                                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                        output.ObjectSpacePosition = input.positionOS;

                                                                        return output;
                                                                    }
                                                                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                                    {
                                                                        SurfaceDescriptionInputs output;
                                                                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                                    #ifdef HAVE_VFX_MODIFICATION
                                                                        // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                                        /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                                    #endif







                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                                    #else
                                                                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                                    #endif
                                                                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                                            return output;
                                                                    }

                                                                    // --------------------------------------------------
                                                                    // Main

                                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

                                                                    // --------------------------------------------------
                                                                    // Visual Effect Vertex Invocations
                                                                    #ifdef HAVE_VFX_MODIFICATION
                                                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                                    #endif

                                                                    ENDHLSL
                                                                    }
                                                                    Pass
                                                                    {
                                                                        // Name: <None>
                                                                        Tags
                                                                        {
                                                                            "LightMode" = "Universal2D"
                                                                        }

                                                                        // Render State
                                                                        Cull[_Cull]
                                                                        Blend[_SrcBlend][_DstBlend]
                                                                        ZTest[_ZTest]
                                                                        ZWrite[_ZWrite]

                                                                        // Debug
                                                                        // <None>

                                                                        // --------------------------------------------------
                                                                        // Pass

                                                                        HLSLPROGRAM

                                                                        // Pragmas
                                                                        #pragma target 2.0
                                                                        #pragma only_renderers gles gles3 glcore d3d11
                                                                        #pragma multi_compile_instancing
                                                                        #pragma vertex vert
                                                                        #pragma fragment frag

                                                                        // DotsInstancingOptions: <None>
                                                                        // HybridV1InjectedBuiltinProperties: <None>

                                                                        // Keywords
                                                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                        // GraphKeywords: <None>

                                                                        // Defines

                                                                        #define _NORMALMAP 1
                                                                        #define _NORMAL_DROPOFF_TS 1
                                                                        #define ATTRIBUTES_NEED_NORMAL
                                                                        #define ATTRIBUTES_NEED_TANGENT
                                                                        #define VARYINGS_NEED_POSITION_WS
                                                                        #define FEATURES_GRAPH_VERTEX
                                                                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                                        #define SHADERPASS SHADERPASS_2D
                                                                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */


                                                                        // custom interpolator pre-include
                                                                        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

                                                                        // Includes
                                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

                                                                        // --------------------------------------------------
                                                                        // Structs and Packing

                                                                        // custom interpolators pre packing
                                                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

                                                                        struct Attributes
                                                                        {
                                                                             float3 positionOS : POSITION;
                                                                             float3 normalOS : NORMAL;
                                                                             float4 tangentOS : TANGENT;
                                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                                             uint instanceID : INSTANCEID_SEMANTIC;
                                                                            #endif
                                                                        };
                                                                        struct Varyings
                                                                        {
                                                                             float4 positionCS : SV_POSITION;
                                                                             float3 positionWS;
                                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                            #endif
                                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                            #endif
                                                                        };
                                                                        struct SurfaceDescriptionInputs
                                                                        {
                                                                             float3 ObjectSpacePosition;
                                                                             float3 AbsoluteWorldSpacePosition;
                                                                        };
                                                                        struct VertexDescriptionInputs
                                                                        {
                                                                             float3 ObjectSpaceNormal;
                                                                             float3 ObjectSpaceTangent;
                                                                             float3 ObjectSpacePosition;
                                                                        };
                                                                        struct PackedVaryings
                                                                        {
                                                                             float4 positionCS : SV_POSITION;
                                                                             float3 interp0 : INTERP0;
                                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                                             uint instanceID : CUSTOM_INSTANCE_ID;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                            #endif
                                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                            #endif
                                                                        };

                                                                        PackedVaryings PackVaryings(Varyings input)
                                                                        {
                                                                            PackedVaryings output;
                                                                            ZERO_INITIALIZE(PackedVaryings, output);
                                                                            output.positionCS = input.positionCS;
                                                                            output.interp0.xyz = input.positionWS;
                                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                                            output.instanceID = input.instanceID;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                            #endif
                                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                            output.cullFace = input.cullFace;
                                                                            #endif
                                                                            return output;
                                                                        }

                                                                        Varyings UnpackVaryings(PackedVaryings input)
                                                                        {
                                                                            Varyings output;
                                                                            output.positionCS = input.positionCS;
                                                                            output.positionWS = input.interp0.xyz;
                                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                                            output.instanceID = input.instanceID;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                            #endif
                                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                            output.cullFace = input.cullFace;
                                                                            #endif
                                                                            return output;
                                                                        }


                                                                        // --------------------------------------------------
                                                                        // Graph

                                                                        // Graph Properties
                                                                        CBUFFER_START(UnityPerMaterial)
                                                                        half _Edge;
                                                                        half4 _BaseColor;
                                                                        half4 _ReplaceableColor;
                                                                        half _NoiseScale;
                                                                        half _NormalizeCoefficient;
                                                                        half _Smoothness;
                                                                        half _Metallic;
                                                                        CBUFFER_END

                                                                            // Object and Global properties

                                                                            // Graph Includes
                                                                            // GraphIncludes: <None>

                                                                            // -- Property used by ScenePickingPass
                                                                            #ifdef SCENEPICKINGPASS
                                                                            float4 _SelectionID;
                                                                            #endif

                                                                        // -- Properties used by SceneSelectionPass
                                                                        #ifdef SCENESELECTIONPASS
                                                                        int _ObjectId;
                                                                        int _PassValue;
                                                                        #endif

                                                                        // Graph Functions

                                                                        void Unity_Distance_float2(float2 A, float2 B, out float Out)
                                                                        {
                                                                            Out = distance(A, B);
                                                                        }

                                                                        void Unity_Divide_float(float A, float B, out float Out)
                                                                        {
                                                                            Out = A / B;
                                                                        }


                                                                        float2 Unity_GradientNoise_Dir_float(float2 p)
                                                                        {
                                                                            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                                                                            p = p % 289;
                                                                            // need full precision, otherwise half overflows when p > 1
                                                                            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
                                                                            x = (34 * x + 1) * x % 289;
                                                                            x = frac(x / 41) * 2 - 1;
                                                                            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                                                                        }

                                                                        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                                                                        {
                                                                            float2 p = UV * Scale;
                                                                            float2 ip = floor(p);
                                                                            float2 fp = frac(p);
                                                                            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                                                                            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                                                                            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                                                                            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                                                                            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                                                                            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                                                                        }

                                                                        void Unity_Add_float(float A, float B, out float Out)
                                                                        {
                                                                            Out = A + B;
                                                                        }

                                                                        void Unity_Step_float(float Edge, float In, out float Out)
                                                                        {
                                                                            Out = step(Edge, In);
                                                                        }

                                                                        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                        {
                                                                            Out = A * B;
                                                                        }

                                                                        void Unity_OneMinus_float(float In, out float Out)
                                                                        {
                                                                            Out = 1 - In;
                                                                        }

                                                                        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                                                                        {
                                                                            Out = A + B;
                                                                        }

                                                                        // Custom interpolators pre vertex
                                                                        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

                                                                        // Graph Vertex
                                                                        struct VertexDescription
                                                                        {
                                                                            half3 Position;
                                                                            half3 Normal;
                                                                            half3 Tangent;
                                                                        };

                                                                        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                                        {
                                                                            VertexDescription description = (VertexDescription)0;
                                                                            description.Position = IN.ObjectSpacePosition;
                                                                            description.Normal = IN.ObjectSpaceNormal;
                                                                            description.Tangent = IN.ObjectSpaceTangent;
                                                                            return description;
                                                                        }

                                                                        // Custom interpolators, pre surface
                                                                        #ifdef FEATURES_GRAPH_VERTEX
                                                                        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
                                                                        {
                                                                        return output;
                                                                        }
                                                                        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
                                                                        #endif

                                                                        // Graph Pixel
                                                                        struct SurfaceDescription
                                                                        {
                                                                            float3 BaseColor;
                                                                            half Alpha;
                                                                            half AlphaClipThreshold;
                                                                        };

                                                                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                        {
                                                                            SurfaceDescription surface = (SurfaceDescription)0;
                                                                            half4 _Property_ffa90d3b3f77485e984796da11d0ac19_Out_0 = _BaseColor;
                                                                            half _Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0 = _Edge;
                                                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_R_1 = IN.ObjectSpacePosition[0];
                                                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_G_2 = IN.ObjectSpacePosition[1];
                                                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_B_3 = IN.ObjectSpacePosition[2];
                                                                            float _Split_781cad85a9f046a8980ed2a1d2d10664_A_4 = 0;
                                                                            float2 _Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0 = float2(_Split_781cad85a9f046a8980ed2a1d2d10664_R_1, _Split_781cad85a9f046a8980ed2a1d2d10664_B_3);
                                                                            float _Distance_767d57b101584aec91e1737df8c8189a_Out_2;
                                                                            Unity_Distance_float2(_Vector2_f4ff0430bc9a4f4f8fd6354e5c98ffbd_Out_0, float2(0, 0), _Distance_767d57b101584aec91e1737df8c8189a_Out_2);
                                                                            half _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0 = _NormalizeCoefficient;
                                                                            float _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2;
                                                                            Unity_Divide_float(_Distance_767d57b101584aec91e1737df8c8189a_Out_2, _Property_3fe1f38325284538ae34381ee5a9ee8e_Out_0, _Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2);
                                                                            float _Split_0adf1cac2e75421a859d31b60cd64966_R_1 = IN.AbsoluteWorldSpacePosition[0];
                                                                            float _Split_0adf1cac2e75421a859d31b60cd64966_G_2 = IN.AbsoluteWorldSpacePosition[1];
                                                                            float _Split_0adf1cac2e75421a859d31b60cd64966_B_3 = IN.AbsoluteWorldSpacePosition[2];
                                                                            float _Split_0adf1cac2e75421a859d31b60cd64966_A_4 = 0;
                                                                            float2 _Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0 = float2(_Split_0adf1cac2e75421a859d31b60cd64966_R_1, _Split_0adf1cac2e75421a859d31b60cd64966_B_3);
                                                                            half _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0 = _NoiseScale;
                                                                            float _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2;
                                                                            Unity_GradientNoise_float(_Vector2_ddfc25319aca464eb6e33e94428d5846_Out_0, _Property_17ee25ff8861408a85cf6b8353d30b63_Out_0, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2);
                                                                            float _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2;
                                                                            Unity_Add_float(_Divide_c68b9d3de99e4dadb17ac58b522e505b_Out_2, _GradientNoise_d52de0d5cf79422caea67be535160209_Out_2, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2);
                                                                            float _Step_737f617fc2ec402a993374a78d94cdff_Out_2;
                                                                            Unity_Step_float(_Property_a2109c5df5ad4887b00ad9e499688ec1_Out_0, _Add_6fb5d3a1db614c66971b3ba23bda7211_Out_2, _Step_737f617fc2ec402a993374a78d94cdff_Out_2);
                                                                            float4 _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2;
                                                                            Unity_Multiply_float4_float4(_Property_ffa90d3b3f77485e984796da11d0ac19_Out_0, (_Step_737f617fc2ec402a993374a78d94cdff_Out_2.xxxx), _Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2);
                                                                            float _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1;
                                                                            Unity_OneMinus_float(_Step_737f617fc2ec402a993374a78d94cdff_Out_2, _OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1);
                                                                            half4 _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0 = _ReplaceableColor;
                                                                            float4 _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2;
                                                                            Unity_Multiply_float4_float4((_OneMinus_9e597368ea624268a25587aaeb28ad48_Out_1.xxxx), _Property_9e984235f2e64da1b0f1bdc55a26b9bd_Out_0, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2);
                                                                            float4 _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2;
                                                                            Unity_Add_float4(_Multiply_7929f34fd10049bc8fd65628c121b64d_Out_2, _Multiply_06564d1038644a32beeb7aaf08c84e33_Out_2, _Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2);
                                                                            surface.BaseColor = (_Add_3afedfd857d34bf3890001ccc3eb19ff_Out_2.xyz);
                                                                            surface.Alpha = 1;
                                                                            surface.AlphaClipThreshold = 0.5;
                                                                            return surface;
                                                                        }

                                                                        // --------------------------------------------------
                                                                        // Build Graph Inputs
                                                                        #ifdef HAVE_VFX_MODIFICATION
                                                                        #define VFX_SRP_ATTRIBUTES Attributes
                                                                        #define VFX_SRP_VARYINGS Varyings
                                                                        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
                                                                        #endif
                                                                        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                                        {
                                                                            VertexDescriptionInputs output;
                                                                            ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                            output.ObjectSpaceNormal = input.normalOS;
                                                                            output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                            output.ObjectSpacePosition = input.positionOS;

                                                                            return output;
                                                                        }
                                                                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                                        {
                                                                            SurfaceDescriptionInputs output;
                                                                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                                                        #ifdef HAVE_VFX_MODIFICATION
                                                                            // FragInputs from VFX come from two places: Interpolator or CBuffer.
                                                                            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

                                                                        #endif







                                                                            output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
                                                                            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
                                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                                                                        #else
                                                                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                                                                        #endif
                                                                        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                                                                return output;
                                                                        }

                                                                        // --------------------------------------------------
                                                                        // Main

                                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

                                                                        // --------------------------------------------------
                                                                        // Visual Effect Vertex Invocations
                                                                        #ifdef HAVE_VFX_MODIFICATION
                                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
                                                                        #endif

                                                                        ENDHLSL
                                                                        }
                                        }
                                            CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
                                                                            CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
                                                                            FallBack "Hidden/Shader Graph/FallbackError"
}