//
//  ButtonInputBridge.m
//  emuThreeDS
//
//  Created by Antique on 19/4/2023.
//

// MARK: https://github.com/rinsuki/citra

#import "ButtonInputBridge.h"

@implementation ButtonInputBridge {
    ButtonBridge<bool>* _cppBridge;
}

-(nonnull id) init {
    if(self = [super init]) {
        _cppBridge = new ButtonBridge<bool>(false);
    } return self;
}

-(void) valueChangedHandler:(nonnull GCControllerButtonInput *)input value:(float)value pressed:(BOOL)pressed {
    _cppBridge->current_value = pressed;
}

-(ButtonBridge<bool> *) getCppBridge {
    return _cppBridge;
}
@end


@implementation AnalogInputBridge {
    AnalogBridge* _cppBridge;
}

-(nonnull id) init {
    if (self = [super init]) {
        _cppBridge = new AnalogBridge(Float2D{0, 0});
    } return self;
}

-(void) valueChangedHandler:(nonnull GCControllerDirectionPad *)input x:(float)xValue y:(float)yValue {
    _cppBridge->current_value.exchange(Float2D{xValue, yValue});
}

-(AnalogBridge *) getCppBridge {
    return _cppBridge;
}
@end
