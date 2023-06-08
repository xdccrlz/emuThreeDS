//
//  SuperController.swift
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

import GameController

class SuperController {
    var virtualController: GCVirtualController? = nil
    
    
    var handleA: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let aButton = virtualController?.controller?.extendedGamepad?.buttonA else {
                return
            }
            
            aButton.valueChangedHandler = handleA
        }
    }
    
    var handleB: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let bButton = virtualController?.controller?.extendedGamepad?.buttonB else {
                return
            }
            
            bButton.valueChangedHandler = handleB
        }
    }
    
    var handleX: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let xButton = virtualController?.controller?.extendedGamepad?.buttonX else {
                return
            }
            
            xButton.valueChangedHandler = handleX
        }
    }
    
    var handleY: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let yButton = virtualController?.controller?.extendedGamepad?.buttonY else {
                return
            }
            
            yButton.valueChangedHandler = handleY
        }
    }
    
    var handleLeftShoulder: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let lShoulder = virtualController?.controller?.extendedGamepad?.leftShoulder else {
                return
            }
            
            lShoulder.valueChangedHandler = handleLeftShoulder
        }
    }
    
    var handleRightShoulder: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let rShoulder = virtualController?.controller?.extendedGamepad?.rightShoulder else {
                return
            }
            
            rShoulder.valueChangedHandler = handleRightShoulder
        }
    }
    
    var handleLeftThumbstick: GCControllerDirectionPadValueChangedHandler? = nil {
        didSet {
            guard let lThumbstick = virtualController?.controller?.extendedGamepad?.leftThumbstick else {
                return
            }
            
            lThumbstick.valueChangedHandler = handleLeftThumbstick
        }
    }
    
    var handleRightThumbstick: GCControllerDirectionPadValueChangedHandler? = nil {
        didSet {
            guard let rThumbstick = virtualController?.controller?.extendedGamepad?.rightThumbstick else {
                return
            }
            
            rThumbstick.valueChangedHandler = handleRightThumbstick
        }
    }
    
    var handleLeftTrigger: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let lTrigger = virtualController?.controller?.extendedGamepad?.leftTrigger else {
                return
            }
            
            lTrigger.valueChangedHandler = handleLeftTrigger
        }
    }
    
    var handleRightTrigger: GCControllerButtonValueChangedHandler? = nil {
        didSet {
            guard let rTrigger = virtualController?.controller?.extendedGamepad?.rightTrigger else {
                return
            }
            
            rTrigger.valueChangedHandler = handleRightTrigger
        }
    }
    
    
    
    
    
    
    init(elements: Set<String>) {
        var isMacCatalyst = false

#if targetEnvironment(macCatalyst)
        print("App running on macOS with Catalyst")
        isMacCatalyst = true
#else
        print("App running without Catalyst")
#endif
        
        let isKeyboardConnected = GCKeyboard.coalesced != nil || isMacCatalyst
        if isKeyboardConnected {
            print("Keyboard is connected")
        }
        
        let isGamepadConnected = GCController.controllers().count > 0
        if isGamepadConnected {
            print("Gamepad is connected")
        }
        
        if !isGamepadConnected {
            print("There is no gamepad so just create Virtual one")
            virtualController = createVirtualController(elements)
        }
    }
    
    func connect() async throws {
        if let virtualController = virtualController {
            try await virtualController.connect()
        }
    }
    
    func disconnect() {
        if let virtualController = virtualController {
            virtualController.disconnect()
        }
    }
}


let createVirtualController = { (elements: Set<String>) -> GCVirtualController in
    let virtualConfiguration = GCVirtualController.Configuration()
    virtualConfiguration.elements = elements
    
    let virtualController = GCVirtualController(configuration: virtualConfiguration)
    return virtualController
}
