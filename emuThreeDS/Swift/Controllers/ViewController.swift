//
//  ViewController.swift
//  emuThreeDS
//
//  Created by Antique on 4/4/2023.
//

import Foundation
import GameController
import MetalKit
import ToastKit
import UIKit

class ViewController : UIViewController, UIGestureRecognizerDelegate {
    var romPath: String!
    var thread: Thread!
    let wrapper = CoreWrapper()
    
    var topScreen: MTKView!
    var layer: CAMetalLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        topScreen = MTKView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        topScreen.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topScreen)
        view.addConstraints([
            topScreen.topAnchor.constraint(equalTo: view.topAnchor),
            topScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        var loadConfiguration = UIButton.Configuration.gray()
        loadConfiguration.image = UIImage(systemName: "gearshape")?.applyingSymbolConfiguration(.init(scale: .medium))?.applyingSymbolConfiguration(.init(hierarchicalColor: .white))
        loadConfiguration.buttonSize = .medium
        loadConfiguration.cornerStyle = .capsule
        
        let optionsButton = UIButton(configuration: loadConfiguration)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.menu = UIMenu(children: [
            UIMenu(title: "Amiibo", image: UIImage(systemName: "person.crop.circle"), children: [
                UIAction(title: "Insert", image: UIImage(systemName: "person.crop.circle.badge.plus"), handler: { _ in }),
                UIAction(title: "Remove", image: UIImage(systemName: "person.crop.circle.badge.minus"), handler: { _ in })
            ]),
            UIMenu(title: "State", image: UIImage(systemName: "doc"), children: [
                UIAction(title: "Load", image: UIImage(systemName: "arrow.up.doc"), handler: { _ in
                    guard let saveStates = self.wrapper.listSaveStates() as? [SaveState] else {
                        return
                    }
                    
                    let alertController = UIAlertController(title: "Save States", message: "Select a save state to load it.", preferredStyle: .actionSheet)
                    saveStates.forEach { saveState in
                        let date = Date(timeIntervalSince1970: TimeInterval(saveState.time))
                    
                        alertController.addAction(UIAlertAction(title: date.formatted(date: .abbreviated, time: .shortened), style: .default, handler: { _ in
                            self.wrapper.run = false
                            DispatchQueue.main.async {
                                self.wrapper.load(saveState)
                                self.wrapper.run = true
                            }
                        }))
                    }
                    alertController.addAction(UIAlertAction(title: Common.cancel, style: .cancel))
                    self.present(alertController, animated: true)
                }),
                UIAction(title: "Save", image: UIImage(systemName: "arrow.down.doc"), handler: { _ in
                    DispatchQueue.main.async {
                        let saved = self.wrapper.saveState()
                        (self.view.window as! ToastWindow).toast(toast: Toast(prompt: Prompt(title: saved ? "Successfully saved." : "Error saving."), style: saved ? .success : .error))
                    }
                })
            ]),
            UIAction(title: "Exit", image: UIImage(systemName: "xmark.app.fill"), attributes: [.destructive], handler: { _ in
                self.wrapper.run = false
                self.dismiss(animated: true)
            })
        ])
        optionsButton.showsMenuAsPrimaryAction = true
        view.addSubview(optionsButton)
        view.addConstraints([
            optionsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            optionsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: NSNotification.Name.GCControllerDidBecomeCurrent, object: nil)
        
        layer = (topScreen.layer as! CAMetalLayer)
        thread = Thread(target: self, selector: #selector(run), object: nil)
        thread.qualityOfService = .userInteractive
        thread.name = "emuThreeDS"
    }
    
    @objc func run() {
        wrapper.run = true
        wrapper.insertRom(romPath, layer: layer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.thread.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.thread.cancel()
    }
    
    @objc func controllerDidConnect() {
        guard let controller = GCController.current else {
            return
        }

        controller.extendedGamepad?.buttonA.valueChangedHandler = EmulatorInput.buttonA.valueChangedHandler
        controller.extendedGamepad?.buttonA.valueChangedHandler = EmulatorInput.buttonA.valueChangedHandler
        controller.extendedGamepad?.buttonB.valueChangedHandler = EmulatorInput.buttonB.valueChangedHandler
        controller.extendedGamepad?.buttonX.valueChangedHandler = EmulatorInput.buttonX.valueChangedHandler
        controller.extendedGamepad?.buttonY.valueChangedHandler = EmulatorInput.buttonY.valueChangedHandler
        controller.extendedGamepad?.dpad.up.valueChangedHandler = EmulatorInput.dpadUp.valueChangedHandler
        controller.extendedGamepad?.dpad.left.valueChangedHandler = EmulatorInput.dpadLeft.valueChangedHandler
        controller.extendedGamepad?.dpad.down.valueChangedHandler = EmulatorInput.dpadDown.valueChangedHandler
        controller.extendedGamepad?.dpad.right.valueChangedHandler = EmulatorInput.dpadRight.valueChangedHandler
        controller.extendedGamepad?.leftShoulder.valueChangedHandler = EmulatorInput.buttonL.valueChangedHandler
        controller.extendedGamepad?.rightShoulder.valueChangedHandler = EmulatorInput.buttonR.valueChangedHandler
        
        controller.extendedGamepad?.buttonOptions?.valueChangedHandler = EmulatorInput.buttonSelect.valueChangedHandler
        controller.extendedGamepad?.buttonMenu.valueChangedHandler = EmulatorInput.buttonStart.valueChangedHandler
        
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = EmulatorInput.circlePad.valueChangedHandler
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler = EmulatorInput.circlePadPro.valueChangedHandler
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: view)
        print(location.x * 2, location.y)
        
        wrapper.touch(location)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}
