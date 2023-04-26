// Copyright 2022 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <string_view>

namespace HostShaders {

constexpr std::string_view Y_GRADIENT_FRAG = {
"// Copyright 2022 Citra Emulator Project\n"
"// Licensed under GPLv2 or any later version\n"
"// Refer to the license.txt file included.\n"
"\n"
"//? #version 430 core\n"
"precision mediump float;\n"
"\n"
"layout(location = 0) in vec2 tex_coord;\n"
"layout(location = 0) out float frag_color;\n"
"\n"
"layout(binding = 0) uniform sampler2D tex_input;\n"
"\n"
"void main() {\n"
"    vec2 t = textureLodOffset(tex_input, tex_coord, 0.0, ivec2(0, 1)).xy;\n"
"    vec2 c = textureLod(tex_input, tex_coord, 0.0).xy;\n"
"    vec2 b = textureLodOffset(tex_input, tex_coord, 0.0, ivec2(0, -1)).xy;\n"
"\n"
"    vec2 grad = vec2(t.x + 2.0 * c.x + b.x, b.y - t.y);\n"
"\n"
"    frag_color = 1.0 - length(grad);\n"
"}\n"
"\n"

};

} // namespace HostShaders
