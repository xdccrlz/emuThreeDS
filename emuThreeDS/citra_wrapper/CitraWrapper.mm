//
//  CitraWrapper.mm
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

#include <Foundation/Foundation.h>
#import "CitraWrapper.h"

#include "config.h"
#include "file_handle.h"
#include "core/core.h"
#include "core/loader/smdh.h"
#include "emu_window_vk.h"
#include "game_info.h"

Core::System& core{Core::System::GetInstance()};
std::unique_ptr<EmuWindow_VK> emu_window;

@implementation CitraWrapper
+(CitraWrapper *) sharedInstance {
    static CitraWrapper *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CitraWrapper alloc] init];
    });
    
    return instance;
}


-(uint16_t*) GetIcon:(NSString *)path {
    auto icon = GameInfo::GetIcon(std::string([path UTF8String]));
    return icon.data(); // huh? "Address of stack memory associated with local variable 'icon' returned"
}

-(NSString *) GetPublisher:(NSString *)path {
    auto publisher = GameInfo::GetPublisher(std::string([path UTF8String]));
    return [NSString stringWithCharacters:(const unichar*)publisher.c_str() length:publisher.length()];
}

-(NSString *) GetTitle:(NSString *)path {
    auto title = GameInfo::GetTitle(std::string([path UTF8String]));
    return [NSString stringWithCharacters:(const unichar*)title.c_str() length:title.length()];
}


-(void) useMetalLayer:(CAMetalLayer *)layer {
    _metalLayer = layer;
    emu_window = std::make_unique<EmuWindow_VK>((__bridge CA::MetalLayer*)_metalLayer);
}

-(void) load:(NSString *)path {
    Config{};
    
    Settings::values.layout_option.SetValue(Settings::LayoutOption::Default);
    Settings::values.custom_layout.SetValue(true);
    Settings::values.custom_top_top.SetValue(0);
    Settings::values.custom_top_left.SetValue(0);
    Settings::values.custom_top_bottom.SetValue(ResolutionHandle::GetScreenWidth() * 0.6);
    Settings::values.custom_top_right.SetValue(ResolutionHandle::GetScreenWidth());
    
    Settings::values.custom_bottom_top.SetValue(ResolutionHandle::GetScreenWidth() * 0.6);
    Settings::values.custom_bottom_left.SetValue(0);
    Settings::values.custom_bottom_bottom.SetValue((ResolutionHandle::GetScreenWidth() * 0.6) + (ResolutionHandle::GetScreenWidth() * 0.75));
    Settings::values.custom_bottom_right.SetValue(ResolutionHandle::GetScreenWidth());
    
    Settings::values.resolution_factor.SetValue(2);
    
    Settings::Apply();
    
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:NULL];
    [_thread setName:@"emuThreeDS"];
    [_thread setQualityOfService:NSQualityOfServiceUserInteractive];
    [_thread setThreadPriority:1.0];
    
    _path = path;
}

-(void) pause {
    _isPaused = true;
}

-(void) run {
    if (![_thread isExecuting])
        auto resultStatus = core.Load(*emu_window, std::string([_path UTF8String]));
    
    _isRunning = true;
    _isPaused = false;
    if (![_thread isExecuting])
        [_thread start];
}

-(void) start {
    while (_isRunning) {
        if (!_isPaused) {
            Settings::values.volume.SetValue(1);
            Core::System::ResultStatus result = core.RunLoop();
            switch (result) {
                default:
                    break;
            }
        } else {
            Settings::values.volume.SetValue(0);
            emu_window->PollEvents();
        }
    }
}


-(void) touchesBegan:(CGPoint)point {
    NSLog(@"%d, %d", point.x, point.y);
    emu_window->OnTouchEvent((point.x * [[UIScreen mainScreen] scale]) + 0.5, (point.y * [[UIScreen mainScreen] scale]) + 0.5, true);
}

-(void) touchesMoved:(CGPoint)point {
    emu_window->OnTouchMoved((point.x * [[UIScreen mainScreen] scale]) + 0.5, (point.y * [[UIScreen mainScreen] scale]) + 0.5);
}

-(void) touchesEnded {
    emu_window->OnTouchReleased();
}
@end
