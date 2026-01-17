#version 330 core

vec4 picom_shader(vec4 color) {
    float gray = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    return vec4(vec3(gray), color.a);
}
