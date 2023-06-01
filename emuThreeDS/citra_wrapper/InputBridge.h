//
//  InputBridge.h
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

#pragma once

#ifdef __cplusplus
#include "core/frontend/input.h"

template <typename StatusType>
class ButtonBridge : public Input::InputDevice<StatusType> {
public:
    std::atomic<StatusType> current_value;

    ButtonBridge(StatusType initial_value) {
        current_value = initial_value;
    }

    StatusType GetStatus() const {
        return current_value;
    }
};

struct Float2D {
    float x;
    float y;
};

//struct Float3D {
//    Common::Vec3<float> acceleration;
//    Common::Vec3<float> rotation;
//};

class AnalogBridge : public Input::InputDevice<std::tuple<float, float>> {
public:
    std::atomic<Float2D> current_value;

    AnalogBridge(Float2D initial_value) {
        current_value = initial_value;
    }

    std::tuple<float, float> GetStatus() const {
        Float2D cv = current_value.load();
        return { cv.x, cv.y };
    }
};
#endif

#import <Foundation/Foundation.h>
#import <GameController/GameController.h>

NS_ASSUME_NONNULL_BEGIN
@interface ButtonInputBridge: NSObject
-(id) init;
-(void) valueChangedHandler:(GCControllerButtonInput *)input value:(float)value pressed:(BOOL)pressed;

#ifdef __cplusplus
-(ButtonBridge<bool> *) getCppBridge;
#endif
@end

@interface AnalogInputBridge: NSObject
-(id) init;
-(void) valueChangedHandler:(GCControllerDirectionPad *)input x:(float)xValue y:(float)yValue;

#ifdef __cplusplus
-(AnalogBridge *) getCppBridge;
#endif
@end
NS_ASSUME_NONNULL_END
