//
//  CitraWrapper.mm
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

#import <Foundation/Foundation.h>
#import "CitraWrapper.h"
#import "InputFactory.h"

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

-(NSString *) GetRegion:(NSString *)path {
    auto regions = GameInfo::GetRegions(std::string([path UTF8String]));
    return [NSString stringWithCString:regions.c_str() encoding:NSUTF8StringEncoding];
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
    
    Settings::values.layout_option.SetValue((Settings::LayoutOption)[[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"portrait_layout_option"]] unsignedIntValue]);
    Settings::values.resolution_factor.SetValue([[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"resolution_factor"]] unsignedIntValue]);
    
    Settings::values.use_cpu_jit.SetValue([[NSUserDefaults standardUserDefaults] boolForKey:@"use_cpu_jit"]);
    for (const auto& service_module : Service::service_module_map) {
        Settings::values.lle_modules.emplace(service_module.name, ![[NSUserDefaults standardUserDefaults] boolForKey:@"use_hle"]);
    }
    
    
    for (int i = 0; i < Settings::NativeButton::NumButtons; i++) {
        Common::ParamPackage param{ { "engine", "ios_gamepad" }, { "code", std::to_string(i) } };
        Settings::values.current_input_profile.buttons[i] = param.Serialize();
    }
    
    for (int i = 0; i < Settings::NativeAnalog::NumAnalogs; i++) {
        Common::ParamPackage param{ { "engine", "ios_gamepad" }, { "code", std::to_string(i) } };
        Settings::values.current_input_profile.analogs[i] = param.Serialize();
    }
    
    
    Input::RegisterFactory<Input::ButtonDevice>("ios_gamepad", std::make_shared<ButtonFactory>());
    Input::RegisterFactory<Input::AnalogDevice>("ios_gamepad", std::make_shared<AnalogFactory>());
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
    emu_window->OnTouchEvent((point.x * [[UIScreen mainScreen] nativeScale]) + 0.5, (point.y * [[UIScreen mainScreen] nativeScale]) + 0.5, true);
}

-(void) touchesMoved:(CGPoint)point {
    emu_window->OnTouchMoved((point.x * [[UIScreen mainScreen] nativeScale]) + 0.5, (point.y * [[UIScreen mainScreen] nativeScale]) + 0.5);
}

-(void) touchesEnded {
    emu_window->OnTouchReleased();
}


-(void) orientationChanged:(UIDeviceOrientation)orientation with:(CAMetalLayer *)surface {
    if (_isRunning && !_isPaused) {
        if (orientation == UIDeviceOrientationPortrait) {
            Settings::values.layout_option.SetValue((Settings::LayoutOption)[[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"portrait_layout_option"]] unsignedIntValue]);
        } else {
            Settings::values.layout_option.SetValue((Settings::LayoutOption)[[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"landscape_layout_option"]] unsignedIntValue]);
        }
        
        emu_window->OrientationChanged(orientation == UIDeviceOrientationPortrait, (__bridge CA::MetalLayer*)surface);
    }
}
@end
