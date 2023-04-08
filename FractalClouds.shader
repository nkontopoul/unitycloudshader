Shader "Custom/FractalClouds" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _CloudColor ("Cloud Color", Color) = (1, 1, 1, 1)
        _Background ("Background Color", Color) = (0, 0, 0, 1)
        _Scale ("Scale", Range(1, 100)) = 10
        _Speed ("Speed", Range(0, 5)) = 1
        _Lacunarity ("Lacunarity", Range(1, 5)) = 2
        _Persistence ("Persistence", Range(0, 1)) = 0.5
        _Octaves ("Octaves", Range(1, 10)) = 4
        _Threshold ("Threshold", Range(0, 1)) = 0.5
    }

    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        float _Scale;
        float _Speed;
        float _Lacunarity;
        float _Persistence;
        int _Octaves;
        float _Threshold;
        float4 _CloudColor;
        float4 _Background;

        #include "UnityCG.cginc"
        #include "SimplexNoise.cginc"

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            float2 uv = IN.uv_MainTex;

            // Generate fractal noise
            float noiseValue = 0;
            float amplitude = 1;
            float frequency = _Scale;
            float maxValue = 0;
            for (int i = 0; i < _Octaves; i++) {
                noiseValue += snoise(uv * frequency + _Speed * _Time.y) * amplitude;
                maxValue += amplitude;
                amplitude *= _Persistence;
                frequency *= _Lacunarity;
            }

            // Normalize the noise value
            noiseValue /= maxValue;

            // Apply threshold
            float mask = step(_Threshold, noiseValue);

            // Mix the background color and the cloud color
            o.Albedo = lerp(_Background.rgb, _CloudColor.rgb, mask);
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
