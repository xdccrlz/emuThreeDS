//
//  RomBrowserViewController.swift
//  emuThreeDS
//
//  Created by Antique on 18/4/2023.
//

import Foundation
import ToastKit
import UIKit


struct Rom : Hashable, Comparable {
    static func < (lhs: Rom, rhs: Rom) -> Bool {
        return lhs.filename < rhs.filename
    }
    
    static func == (lhs: Rom, rhs: Rom) -> Bool {
        return lhs.filename == rhs.filename
    }
    
    enum RomType : Int, CustomStringConvertible {
        var description: String {
            switch self {
            case .cci:
                return "CCI"
            case .cia:
                return "CIA"
            case .n3ds:
                return "3DS"
            }
        }
        
        case cia = 0, cci = 1, n3ds = 2
        
    }
    
    let path: String
    let filename: String
    let type: RomType
    
    func gameName(with wrapper: CoreWrapper) -> String {
        return wrapper.gameTitle(path.appending("/\(filename)"))
    }
}


class RomBrowserViewController : UICollectionViewController {
    let wrapper = CoreWrapper()
    
    var dataSource: UICollectionViewDiffableDataSource<String, Rom>! = nil
    var snapshot: NSDiffableDataSourceSnapshot<String, Rom>! = nil
    
    var roms: [Rom] = []
    
    
    @objc func openSettings() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController(collectionViewLayout: collectionViewLayout))
        settingsViewController.modalPresentationStyle = .fullScreen
        
        present(settingsViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Common.roms
        view.backgroundColor = .systemBackground
        
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettings)), animated: true)
        
        
        let documentsDirectoryURL: URL
        if #available(iOS 16, *) {
            documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(component: "roms")
        } else {
            documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("roms")
        }
        
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            do {
                try FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: false)
            } catch { print(error.localizedDescription) }
        }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: documentsDirectoryURL.path)
            if contents.count == 0 {
                let alertController = UIAlertController(title: "No Roms Found", message: "Place roms within the /roms folder of emuThreeDS's Documents directory.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Common.cancel, style: .cancel))
                present(alertController, animated: true)
            } else {
                //roms = contents.filter { $0.hasSuffix(".3ds") }
                
                contents.filter { $0.hasSuffix(".3ds") || $0.hasSuffix(".cci") }.forEach { filename in
                    roms.append(Rom(path: documentsDirectoryURL.path, filename: filename, type: filename.hasSuffix(".cci") ? .cci : .n3ds))
                }
                
                contents.filter { $0.hasSuffix(".cia") }.forEach { rom in
                    self.wrapper.installCIA(documentsDirectoryURL.appendingPathComponent(rom).path) { path in
                        guard let path = path else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            (self.view.window as! ToastWindow).toast(toast: Toast(prompt:
                                Prompt(title: "Successfully installed \(path.components(separatedBy: "/").last ?? "")."), style: .success), dismissAfter: 2)
                            
                            do {
                                try FileManager.default.removeItem(atPath: documentsDirectoryURL.appendingPathComponent(rom).path)
                            } catch { print(error.localizedDescription) }
                        }
                    }
                }
                
                guard let installedGames = self.wrapper.installedGamePaths() as? [String] else {
                    return
                }
                
                installedGames.forEach { filepath in
                    let path = filepath.components(separatedBy: "/").dropLast(1).joined(separator: "/")
                    guard let filename = filepath.components(separatedBy: "/").last else {
                        return
                    }
                    
                    print(Rom(path: path, filename: filename, type: .cia))
                    roms.append(Rom(path: path, filename: filename, type: .cia))
                }
            }
        } catch {
            let alertController = UIAlertController(title: "Error Loading Roms", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: Common.cancel, style: .cancel, handler: { _ in exit(0) }))
            present(alertController, animated: true)
        }
        
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Rom> { cell, indexPath, itemIdentifier in
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = itemIdentifier.gameName(with: self.wrapper)
            contentConfiguration.secondaryText = itemIdentifier.type.description
            contentConfiguration.secondaryTextProperties.color = itemIdentifier.type == .cci ? .systemOrange : itemIdentifier.type == .cia ? .systemGreen : .tintColor
            cell.contentConfiguration = contentConfiguration
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var contentConfiguration: UIListContentConfiguration
            if #available(iOS 15, *) {
                contentConfiguration = UIListContentConfiguration.extraProminentInsetGroupedHeader()
            } else {
                contentConfiguration = UIListContentConfiguration.plainHeader()
            }
            
            if #available(iOS 15.0, *) {
                contentConfiguration.text = self.dataSource.sectionIdentifier(for: indexPath.section)
            } else {
                contentConfiguration.text = self.snapshot.sectionIdentifiers[indexPath.section]
            }
            
            supplementaryView.contentConfiguration = contentConfiguration
        }
        
        
        
        dataSource = UICollectionViewDiffableDataSource<String, Rom>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        
        
        snapshot = NSDiffableDataSourceSnapshot()
        snapshot.appendSections(roms.reduce(into: [String](), { partialResult, nextItem in
            let title = nextItem.gameName(with: self.wrapper)
            print(title)
            
            
            if (!partialResult.contains(String(title.prefix(1)))) {
                partialResult.append(String(title.prefix(1)))
            }
        }).sorted())
        snapshot.sectionIdentifiers.forEach { identifier in
            let filtered = roms.filter {
                let title = $0.gameName(with: self.wrapper)
                
                return String(title.prefix(1)).contains(identifier) }.sorted()
            snapshot.appendItems(filtered, toSection: identifier)
        }
        
        if #available(iOS 15, *) {
            Task { await dataSource.apply(snapshot) }
        } else {
            dataSource.apply(snapshot)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let romPath = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let viewController = ViewController()
        viewController.romPath = romPath.path.appending("/\(romPath.filename)")
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
