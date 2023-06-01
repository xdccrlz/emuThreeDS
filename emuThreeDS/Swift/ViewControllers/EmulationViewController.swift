//
//  EmulationViewController.swift
//  emuThreeDS
//
//  Created by Antique on 30/5/2023.
//

import Foundation
import GameController
import MetalKit
import UIKit

class EmulationViewController : UIViewController {
    var emulationManager: EmulationManager
    
    var metalView = MTKView()
    
    var virtualController = SuperController(elements: [GCInputLeftThumbstick, GCInputLeftShoulder, GCInputRightShoulder, GCInputButtonMenu, GCInputButtonOptions, GCInputButtonA, GCInputButtonB, GCInputButtonX, GCInputButtonY])
    
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
        if emulationManager.hasConfigured {
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
        print("controller connected")
        
        virtualController.handleA = EmulationInput.buttonA.valueChangedHandler
        virtualController.handleB = EmulationInput.buttonB.valueChangedHandler
        virtualController.handleX = EmulationInput.buttonX.valueChangedHandler
        virtualController.handleY = EmulationInput.buttonY.valueChangedHandler
        
        virtualController.handleOptions = EmulationInput.buttonSelect.valueChangedHandler
        virtualController.handleOptions = EmulationInput.buttonSelect.valueChangedHandler
        
        virtualController.handleThumbstick = EmulationInput.circlePad.valueChangedHandler
    }
}
