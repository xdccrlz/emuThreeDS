//
//  emu_window.hpp
//  emuThreeDS
//
//  Created by Antique on 4/4/2023.
//

#pragma once

#include <vector>

#include "Metal.hpp"
#include "core/frontend/emu_window.h"

class EmuWindow_Apple : public Frontend::EmuWindow {
public:
    EmuWindow_Apple(CA::MetalLayer* surface);
    ~EmuWindow_Apple();
    
    void MakeCurrent() override;
    void DoneCurrent() override;
    
    void PollEvents() override;
    
    virtual void TryPresenting() = 0;
    virtual void DonePresenting() = 0;
    
protected:
    void OnFramebufferSizeChanged();
    
    virtual bool CreateWindowSurface() { return true; }
    virtual void DestroyWindowSurface() {}
    virtual void DestroyContext() {}
    
    CA::MetalLayer* render_window, *host_window;
    std::unique_ptr<Frontend::GraphicsContext> core_context;
    int window_width, window_height;
};
