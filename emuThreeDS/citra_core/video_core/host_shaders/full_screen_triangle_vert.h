// Copyright 2022 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <string_view>

namespace HostShaders {

constexpr std::string_view FULL_SCREEN_TRIANGLE_VERT = {
"// Copyright 2020 yuzu Emulator Project\n"
"// Licensed under GPLv2 or any later version\n"
"// Refer to the license.txt file included.\n"
"\n"
"#version 460 core\n"
"\n"
"#ifdef VULKAN\n"
"#define BEGIN_PUSH_CONSTANTS layout(push_constant) uniform PushConstants {\n"
"#define END_PUSH_CONSTANTS };\n"
"#define UNIFORM(n)\n"
"#else // ^^^ Vulkan ^^^ // vvv OpenGL vvv\n"
"#define BEGIN_PUSH_CONSTANTS\n"
"#define END_PUSH_CONSTANTS\n"
"#define UNIFORM(n) layout (location = n) uniform\n"
"#endif\n"
"\n"
"BEGIN_PUSH_CONSTANTS\n"
"UNIFORM(0) vec2 tex_scale;\n"
"UNIFORM(1) vec2 tex_offset;\n"
"END_PUSH_CONSTANTS\n"
"\n"
"layout(location = 0) out vec2 texcoord;\n"
"\n"
"void main() {\n"
"    float x = float((gl_VertexIndex & 1) << 2);\n"
"    float y = float((gl_VertexIndex & 2) << 1);\n"
"    gl_Position = vec4(x - 1.0, y - 1.0, 0.0, 1.0);\n"
"    texcoord = fma(vec2(x, y) / 2.0, tex_scale, tex_offset);\n"
"}\n"
"\n"

};

} // namespace HostShaders
