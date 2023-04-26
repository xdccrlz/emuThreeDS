//
//  SettingsViewController.swift
//  emuThreeDS
//
//  Created by Antique on 19/4/2023.
//

import Foundation
import SettingsKit
import UIKit


struct Common {
    static let cancel: String = NSLocalizedString("cancel", comment: "")
    static let save: String = NSLocalizedString("save", comment: "")
    
    static let roms: String = NSLocalizedString("roms", comment: "")
    
    static let cornerRadius: CGFloat = 12
}


@objc public class GeneralController : NSObject {
    public var generalIdentifiers: [String]
    
    @objc public override init() {
        generalIdentifiers = UserDefaults.standard.array(forKey: "generalIdentifiers") as? [String] ?? []
    }
    
    @objc public func contains(identifier: String) -> Bool {
        return generalIdentifiers.contains(identifier)
    }
    
    @objc public func toggle(identifier: String) {
        generalIdentifiers.contains(identifier) ? generalIdentifiers.removeAll(where: { $0 == identifier }) : generalIdentifiers.append(identifier)
    }
    
    @objc public func save() {
        UserDefaults.standard.set(generalIdentifiers, forKey: "generalIdentifiers")
    }
}



class SettingsViewController : UICollectionViewController {
    var dataSource: UICollectionViewDiffableDataSource<SettingsModel.Settings.Section, SettingsModel.Settings.Section.Row>! = nil
    var snapshot: NSDiffableDataSourceSnapshot<SettingsModel.Settings.Section, SettingsModel.Settings.Section.Row>! = nil
    
    var settings: SettingsModel.Settings!
    
    var generalController = GeneralController()
    
    var shouldSave: Bool = false {
        didSet {
            if shouldSave {
                navigationItem.setRightBarButton(UIBarButtonItem(systemItem: .save, primaryAction: UIAction(handler: { action in
                    self.generalController.save()
                    
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: .init("settingsDidChange"), object: self.generalController)
                    }
                })), animated: true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setLeftBarButton(UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { action in
            self.dismiss(animated: true)
        })), animated: true)
        title = Settings.title
        view.backgroundColor = .systemBackground
        
        Task {
            await prepareSettings()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let row = dataSource.snapshot().itemIdentifiers(inSection: dataSource.snapshot().sectionIdentifiers[indexPath.section])[indexPath.item]
        shouldSave = true
        
        switch row.configuration.selection {
        case .checkmark:
            generalController.toggle(identifier: row.configuration.identifier)
        case .tappable:
            if generalController.contains(identifier: "resolution_scale") {
                guard let oldScaleString = UserDefaults.standard.string(forKey: "resolution_scale") else {
                    return
                }
                
                var oldScale = Int(oldScaleString) ?? 1
                if oldScale == 1 {
                    oldScale = 2
                } else if oldScale == 2 {
                    oldScale = 3
                } else {
                    oldScale = 1
                }
                
                UserDefaults.standard.set("\(oldScale)", forKey: "resolution_scale")
            } else {
                UserDefaults.standard.set("2", forKey: "resolution_scale")
            }
        default:
            break
        }
        
        
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([row])
        Task {
            await dataSource.apply(snapshot)
        }
    }
}
