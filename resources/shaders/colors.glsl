precision highp float;

#define RGB8(r,g,b)   (vec4((r)/255.0, (g)/255.0, (b)/255.0, 1.0))
#define RGBA8(r,g,b,a) (vec4((r)/255.0, (g)/255.0, (b)/255.0, (a)/255.0))

// Borders
const vec4 border_color = RGB8(102.0, 102.0, 102.0);

// Pie Chart 1
const vec4 pie1_color = RGB8(228.0, 70.0, 196.0);

// Pie Chart 2
const vec4 pie2_color = RGB8(70.0, 206.0, 102.0);

// Pie Chart 3
const vec4 pie3_color = RGB8(236.0, 110.0, 78.0);

// Percentage 1
const vec4 percentage1_color = RGB8(228.0, 70.0, 196.0);

// Percentage 2
const vec4 percentage2_color = RGB8(70.0, 206.0, 102.0);

// Percentage 3
const vec4 percentage3_color = RGB8(236.0, 110.0, 78.0);

// Percentage 4
const vec4 percentage4_color = RGB8(77.0, 225.0, 202.0);

// Text
const vec4 text_color = RGB8(255.0, 255.0, 255.0);

// Text Background
const vec4 text_bg_color = RGB8(102.0, 102.0, 102.0);
