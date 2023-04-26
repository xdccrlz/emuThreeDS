//
//  emu_window_vk.hpp
//  emuThreeDS
//
//  Created by Antique on 4/4/2023.
//

#pragma once

#include "citra/emu_window/emu_window.hpp"

class EmuWindow_VK : public EmuWindow_Apple {
public:
    EmuWindow_VK(CA::MetalLayer* surface);
    ~EmuWindow_VK() override = default;
    
public:
    void TryPresenting() override;
    void DonePresenting() override;
    
    std::unique_ptr<Frontend::GraphicsContext> CreateSharedContext() const override;
    
private:
    bool CreateWindowSurface() override;
};
