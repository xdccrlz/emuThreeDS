//
//  file_handle.h
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

#pragma once

#include <string>

namespace ResolutionHandle {
float StatusBarHeight();
float GetScreenWidth(), GetScreenHeight();
bool IsPortrait();

float CombinedInsets();
}

namespace DefaultsHandle {
bool BoolForKey(std::string key);
}
