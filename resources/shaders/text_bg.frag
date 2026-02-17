varying vec2 f_src_pos;

uniform sampler2D u_texture;

const float threshold = 0.01;

const vec3 ecounter = vec3(0.867, 0.867, 0.867);
const vec3 entities = vec3(0.882, 0.271, 0.761);
const vec3 blockentities = vec3(0.914, 0.427, 0.302);
const vec3 unspecified = vec3(0.271, 0.796, 0.396);
const vec3 spawner = vec3(0.302, 0.882, 0.792);

void main() {
    vec4 color = texture2D(u_texture, f_src_pos);

    bool is_ecounter = all(lessThan(abs(color.rgb - ecounter), vec3(threshold)));
    bool is_entities = all(lessThan(abs(color.rgb - entities), vec3(threshold)));
    bool is_blockentities = all(lessThan(abs(color.rgb - blockentities), vec3(threshold)));
    bool is_unspecified = all(lessThan(abs(color.rgb - unspecified), vec3(threshold)));
    bool is_spawner = all(lessThan(abs(color.rgb - spawner), vec3(threshold)));

    if ( is_blockentities || is_unspecified || is_entities || is_spawner || is_ecounter ) {
        gl_FragColor = text_bg_color;
    }
    else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
