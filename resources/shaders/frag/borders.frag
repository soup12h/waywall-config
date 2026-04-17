precision highp float;

#define RGB8(r,g,b)   (vec4((r)/255.0, (g)/255.0, (b)/255.0, 1.0))
#define RGBA8(r,g,b,a) (vec4((r)/255.0, (g)/255.0, (b)/255.0, (a)/255.0))

const vec4 border_color = RGB8(102.0, 102.0, 102.0); // #666666

//------------------------------------------------------------------------------------------------

varying vec2 f_src_pos;

uniform sampler2D u_texture;

const float threshold = 0.01;

const vec3 ecounter = vec3(1.0, 1.0, 1.0); // #ffffff

void main() {
    vec4 color = texture2D(u_texture, f_src_pos);

    bool is_border = all(lessThan(abs(color.rgb - ecounter), vec3(threshold)));


    if ( is_border ) {
        gl_FragColor = border_color;
    }
    else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
