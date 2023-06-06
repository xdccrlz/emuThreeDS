//
//  EmulationViewController.swift
//  emuThreeDS
//
//  Created by Antique on 30/5/2023.
//

import Foundation
import GameController
import MetalKit
import SwiftUI
import UIKit

class EmulationViewController : UIViewController {
    var emulationManager: EmulationManager
    
    var metalView = MTKView()
    
    var virtualController = SuperController(elements: [GCInputLeftThumbstick, GCInputRightThumbstick, GCInputLeftShoulder, GCInputRightShoulder, GCInputLeftTrigger, GCInputRightTrigger, GCInputButtonA, GCInputButtonB, GCInputButtonX, GCInputButtonY])
    
    init(emulationManager: EmulationManager) {
        self.emulationManager = emulationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.translatesAutoresizingMaskIntoConstraints = false
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.autoResizeDrawable = true
        view.addSubview(metalView)
        view.addConstraints([
            metalView.topAnchor.constraint(equalTo: view.topAnchor),
            metalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            metalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            metalView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !emulationManager.hasConfigured {
            emulationManager.use(layer: metalView.layer as! CAMetalLayer)
        }
        
        emulationManager.run()
        connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disconnect()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if emulationManager.hasConfigured, emulationManager.wrapper.isRunning {
            emulationManager.orientationChanged(orientation: UIDevice.current.orientation, with: metalView.layer as! CAMetalLayer)
        }
        disconnect(); connect()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        emulationManager.touchesBegan(at: touch.location(in: metalView))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        emulationManager.touchesMoved(at: touch.location(in: metalView))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        emulationManager.touchesEnded()
    }
    
    
    func connect() {
        Task {
            try await virtualController.connect()
        }
    }
    
    func disconnect() {
        virtualController.disconnect()
    }
    
    
    @objc func controllerDidConnect() {
        if let controller = GCController.controllers().first(where: { $0.battery != nil }) {
            if let _ = controller.battery {
                virtualController.disconnect()
                
                controller.extendedGamepad?.buttonA.pressedChangedHandler = EmulationInput.buttonA.valueChangedHandler
                controller.extendedGamepad?.buttonB.pressedChangedHandler = EmulationInput.buttonB.valueChangedHandler
                controller.extendedGamepad?.buttonX.pressedChangedHandler = EmulationInput.buttonX.valueChangedHandler
                controller.extendedGamepad?.buttonY.pressedChangedHandler = EmulationInput.buttonY.valueChangedHandler
                
                controller.extendedGamepad?.leftShoulder.pressedChangedHandler = EmulationInput.buttonSelect.valueChangedHandler
                controller.extendedGamepad?.rightShoulder.pressedChangedHandler = EmulationInput.buttonStart.valueChangedHandler
                
                controller.extendedGamepad?.leftTrigger.valueChangedHandler = EmulationInput.buttonL.valueChangedHandler
                controller.extendedGamepad?.rightTrigger.valueChangedHandler = EmulationInput.buttonR.valueChangedHandler
                
                controller.extendedGamepad?.leftThumbstick.valueChangedHandler = EmulationInput.circlePad.valueChangedHandler
                controller.extendedGamepad?.rightThumbstick.valueChangedHandler = EmulationInput.circlePadPro.valueChangedHandler
            } else {
                Task {
                    try await virtualController.connect()
                }
                
                virtualController.handleA = EmulationInput.buttonA.valueChangedHandler
                virtualController.handleB = EmulationInput.buttonB.valueChangedHandler
                virtualController.handleX = EmulationInput.buttonX.valueChangedHandler
                virtualController.handleY = EmulationInput.buttonY.valueChangedHandler
                
                virtualController.handleLeftShoulder = EmulationInput.buttonSelect.valueChangedHandler
                virtualController.handleRightShoulder = EmulationInput.buttonStart.valueChangedHandler
                
                virtualController.handleLeftTrigger = EmulationInput.buttonL.valueChangedHandler
                virtualController.handleRightTrigger = EmulationInput.buttonR.valueChangedHandler
                
                virtualController.handleLeftThumbstick = EmulationInput.circlePad.valueChangedHandler
                virtualController.handleRightThumbstick = EmulationInput.circlePadPro.valueChangedHandler
            }
        }
    }
}
