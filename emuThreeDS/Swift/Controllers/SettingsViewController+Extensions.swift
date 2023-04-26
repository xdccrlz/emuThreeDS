//
//  SettingsViewController+Extensions.swift
//  emuThreeDS
//
//  Created by Antique on 19/4/2023.
//

import Foundation
import SettingsKit
import UIKit

// MARK: SETTINGS
struct Settings {
    static let title: String = NSLocalizedString("settings.title", comment: "")
    
    enum Headers : String {
        case general = "settings.headers.general"
        case customization = "settings.headers.customization"
        
        var string: String {
            return NSLocalizedString(rawValue, comment: "")
        }
    }
}


extension SettingsViewController {
    func prepareSettings() async {
        guard let settingsPath = Bundle.main.path(forResource: "Settings", ofType: "plist"), FileManager.default.fileExists(atPath: settingsPath) else { return }
        
        do {
            let url: URL
            if #available(iOS 16, *) {
                url = URL(filePath: settingsPath)
            } else {
                url = URL(fileURLWithPath: settingsPath)
            }
            
            settings = try PropertyListDecoder().decode(SettingsModel.Settings.self, from: try Data(contentsOf: url))
            await prepareAndApplySnapshot(using: prepareDataSource())
        } catch { print(error.localizedDescription) }
    }
    
    
    func prepareDataSource() -> UICollectionViewDiffableDataSource<SettingsModel.Settings.Section, SettingsModel.Settings.Section.Row> {
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingsModel.Settings.Section.Row> { cell, indexPath, itemIdentifier in
            var contentConfiguration: UIListContentConfiguration
            contentConfiguration = .valueCell()
            switch itemIdentifier.configuration.identifier {
            case "resolution_scale":
                contentConfiguration = .subtitleCell()
                contentConfiguration.secondaryText = "Top: 400x240 | Bottom: 320x240"
            default:
                break
            }
            
            if let localizedIdentifier = itemIdentifier.configuration.localizedIdentifier {
                contentConfiguration.text = NSLocalizedString(localizedIdentifier, comment: "")
            } else {
                contentConfiguration.text = itemIdentifier.configuration.text
            }
            
            
            if let image = itemIdentifier.configuration.image {
                contentConfiguration.image = UIImage(systemName: image)?.applyingSymbolConfiguration(.init(hierarchicalColor: contentConfiguration.imageProperties.tintColor ?? .tintColor))
            }
            
            cell.contentConfiguration = contentConfiguration
            
            switch itemIdentifier.configuration.selection {
            case .checkmark:
                cell.accessories = [
                    .checkmark(displayed: .always, options: .init(isHidden: !self.generalController.contains(identifier: itemIdentifier.configuration.identifier)))
                ]
            default:
                cell.accessories = []
            }
        }
        
        let headerCellRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var contentConfiguration = UIListContentConfiguration.extraProminentInsetGroupedHeader()
            contentConfiguration.text = Settings.Headers(rawValue: self.dataSource.snapshot().sectionIdentifiers[indexPath.section].header ?? "")?.string ?? ""
            supplementaryView.contentConfiguration = contentConfiguration
        }
        
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    func prepareAndApplySnapshot(using: UICollectionViewDiffableDataSource<SettingsModel.Settings.Section, SettingsModel.Settings.Section.Row>) async {
        snapshot = NSDiffableDataSourceSnapshot<SettingsModel.Settings.Section, SettingsModel.Settings.Section.Row>()
        snapshot.appendSections(settings.sections)
        settings.sections.forEach { section in
            snapshot.appendItems(section.rows, toSection: section)
        }
        await dataSource.apply(snapshot)
    }
}

