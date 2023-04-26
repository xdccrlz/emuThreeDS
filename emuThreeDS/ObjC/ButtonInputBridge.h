//
//  ButtonInputBridge.h
//  emuThreeDS
//
//  Created by Antique on 19/4/2023.
//

#import <Foundation/Foundation.h>

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

@interface ButtonInputBridge: NSObject
-(nonnull id) init;
-(void) valueChangedHandler:(nonnull GCControllerButtonInput *)input value:(float)value pressed:(BOOL)pressed;

#ifdef __cplusplus
-(ButtonBridge<bool> *) getCppBridge;
#endif
@end

@interface AnalogInputBridge: NSObject
-(nonnull id) init;
-(void) valueChangedHandler:(nonnull GCControllerDirectionPad *)input x:(float)xValue y:(float)yValue;

#ifdef __cplusplus
-(AnalogBridge *) getCppBridge;
#endif
@end
