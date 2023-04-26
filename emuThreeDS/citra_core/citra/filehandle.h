//
//  filehandle.h
//  emuThreeDS
//
//  Created by Antique on 27/3/2023.
//

#include <cstdint>
#include <string>

namespace filehandle {
std::string rom_path();
}


namespace FolderHandle {
std::string DocumentDirectory();
}


namespace ResolutionHandle {
float GetScreenWidth(), GetScreenHeight();
bool IsPortrait();
}
