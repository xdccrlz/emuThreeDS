// Copyright 2022 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <string_view>

namespace HostShaders {

constexpr std::string_view X_GRADIENT_FRAG = {
"// Copyright 2022 Citra Emulator Project\n"
"// Licensed under GPLv2 or any later version\n"
"// Refer to the license.txt file included.\n"
"\n"
"//? #version 430 core\n"
"precision mediump float;\n"
"\n"
"layout(location = 0) in vec2 tex_coord;\n"
"layout(location = 0) out vec2 frag_color;\n"
"\n"
"layout(binding = 0) uniform sampler2D tex_input;\n"
"\n"
"const vec3 K = vec3(0.2627, 0.6780, 0.0593);\n"
"// TODO: improve handling of alpha channel\n"
"#define GetLum(xoffset) dot(K, textureLodOffset(tex_input, tex_coord, 0.0, ivec2(xoffset, 0)).rgb)\n"
"\n"
"void main() {\n"
"    float l = GetLum(-1);\n"
"    float c = GetLum(0);\n"
"    float r = GetLum(1);\n"
"\n"
"    frag_color = vec2(r - l, l + 2.0 * c + r);\n"
"}\n"
"\n"

};

} // namespace HostShaders
