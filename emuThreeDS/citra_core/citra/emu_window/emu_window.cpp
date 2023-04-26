//
//  emu_window.cpp
//  emuThreeDS
//
//  Created by Antique on 4/4/2023.
//

#include "emu_window.hpp"

#include "network/network.h"

#include "video_core/renderer_base.h"
#include "video_core/video_core.h"

#include "filehandle.h"

EmuWindow_Apple::EmuWindow_Apple(CA::MetalLayer* surface) : host_window{surface} {
    // window width, height
    window_width = ResolutionHandle::GetScreenWidth();
    window_height = ResolutionHandle::GetScreenHeight();
    
    Network::Init();
}

EmuWindow_Apple::~EmuWindow_Apple() {
    DestroyWindowSurface();
    DestroyContext();
}

void EmuWindow_Apple::OnFramebufferSizeChanged() {
    const int bigger{window_width > window_height ? window_width : window_height};
    const int smaller{window_width < window_height ? window_width : window_height};
    
    //bool portait = ResolutionHandle::IsPortrait();
    //if (portait)
    //    UpdateCurrentFramebufferLayout(smaller, bigger, portait);
    //else
    UpdateCurrentFramebufferLayout(bigger, smaller, false);
}

void EmuWindow_Apple::PollEvents() {
    if (!render_window)
        return;
    
    host_window = render_window;
    render_window = nullptr;
    
    DestroyWindowSurface();
    CreateWindowSurface();
    OnFramebufferSizeChanged();
}

void EmuWindow_Apple::MakeCurrent() {
    core_context->MakeCurrent();
}

void EmuWindow_Apple::DoneCurrent() {
    core_context->DoneCurrent();
}
