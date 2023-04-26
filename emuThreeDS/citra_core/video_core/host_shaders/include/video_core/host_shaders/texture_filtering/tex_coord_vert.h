// Copyright 2022 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <string_view>

namespace HostShaders {

constexpr std::string_view TEX_COORD_VERT = {
"// Copyright 2022 Citra Emulator Project\n"
"// Licensed under GPLv2 or any later version\n"
"// Refer to the license.txt file included.\n"
"\n"
"//? #version 430 core\n"
"layout(location = 0) out vec2 tex_coord;\n"
"\n"
"const vec2 vertices[4] =\n"
"    vec2[4](vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0), vec2(1.0, 1.0));\n"
"\n"
"void main() {\n"
"    gl_Position = vec4(vertices[gl_VertexID], 0.0, 1.0);\n"
"    tex_coord = (vertices[gl_VertexID] + 1.0) / 2.0;\n"
"}\n"
"\n"

};

} // namespace HostShaders
