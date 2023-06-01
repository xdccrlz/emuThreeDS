//
//  game_info.hpp
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

#pragma once

#include <string>
#include <vector>

namespace GameInfo {
std::vector<uint8_t> GetSMDHData(std::string physical_name);

std::u16string GetPublisher(std::string physical_name);
std::string GetRegions(std::string physical_name);
std::u16string GetTitle(std::string physical_name);

std::vector<uint16_t> GetIcon(std::string physical_name);
}
