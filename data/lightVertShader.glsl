#define PROCESSING_TEXLIGHT_SHADER

// Uniforms for transformations
uniform mat4 modelview;        // Model-view matrix (camera view)
uniform mat4 transform;        // Final transform (projection or model transformations)
uniform mat3 normalMatrix;     // Normal matrix (inverse-transpose of modelview)

attribute vec4 position;       // Vertex position
attribute vec4 color;          // Vertex color
attribute vec3 normal;         // Vertex normal
attribute vec4 emissive;       // Emissive color
attribute float shininess;     // Shininess coefficient
attribute vec2 texCoord;       // Texture coordinates

// Varying variables for passing data to fragment shader
varying vec4 vertColor;        // Passes color to fragment shader
varying vec4 vertEmissive;     // Passes emissive color to fragment shader
varying float vertShininess;   // Passes shininess to fragment shader
varying vec3 ecNormal;         // Transformed normal in eye-space
varying vec3 ecPosition;       // Transformed position in eye-space
varying vec2 uv;               // Texture coordinates

void main() {
  // Transform position by the final modelview and projection matrix
  gl_Position = transform * position;

  // Compute eye-space position by transforming the vertex with the modelview matrix
  ecPosition = vec3(modelview * position);

  // Transform normal using the normal matrix (inverse-transpose of modelview)
  ecNormal = normalize(normalMatrix * normal);

  // Pass other attributes to fragment shader
  vertEmissive = emissive;
  vertColor = color;
  vertShininess = shininess;
  uv = texCoord;
}
