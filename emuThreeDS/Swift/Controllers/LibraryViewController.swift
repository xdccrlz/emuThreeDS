//
//  LibraryViewController.swift
//  emuThreeDS
//
//  Created by Antique on 15/6/2023.
//

import Foundation
import UIKit
import UniformTypeIdentifiers


class LibraryViewController : UICollectionViewController, ImportingProgressDelegate, UIDocumentPickerDelegate {
    var dataSource: UICollectionViewDiffableDataSource<String, AnyHashable>! = nil
    var snapshot: NSDiffableDataSourceSnapshot<String, AnyHashable>! = nil
    
    var citraWrapper = CitraWrapper.shared()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setLeftBarButton(UIBarButtonItem(systemItem: .add, menu: UIMenu(children: [
            UIAction(title: "Convert CIA", image: UIImage(systemName: "arrow.triangle.2.circlepath.circle.fill"), handler: { action in
                
            }),
            UIAction(title: "Import CIAs", image: UIImage(systemName: "arrow.down.doc.fill"), handler: { action in
                self.openDocumentPicker()
            })
        ])), animated: true)
        title = "Library"
        view.backgroundColor = .systemBackground
        
        
        citraWrapper.delegate = self
        prepareAndDisplayLibrary()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(importingProgressDidFinish(notification:)), name: Notification.Name("importingProgressDidFinish"), object: nil)
    }
    
    
    @objc func importingProgressDidFinish(notification: Notification) {
        guard let fileURL = notification.object as? URL else {
            return
        }
        
        snapshot.appendItems([ImportedItem(gameInfo: self.getImportedItemGameInformation(for: fileURL.path))], toSection: "Imported")
        if #available(iOS 15, *) {
            Task {
                await dataSource.apply(snapshot)
            }
        } else {
            dataSource.apply(snapshot)
        }
    }
    
    
    fileprivate func openDocumentPicker() {
        let documentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [
            UTType("com.nintendo-3ds.cia")!
        ], asCopy: true)
        documentPickerViewController.allowsMultipleSelection = true
        documentPickerViewController.delegate = self
        present(documentPickerViewController, animated: true)
    }
    
    
    // MARK: ImportingProgressDelegate
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    func importingProgressDidChange(_ url: URL, received: CGFloat, total: CGFloat) {
        if (received / total) >= 0.9 {
            impactFeedbackGenerator.impactOccurred()
        }
    }
    
    
    // MARK: UIDocumentPickerDelegate
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        citraWrapper.importCIAs(urls)
    }
}



// MARK: LibraryViewControllerExtension
extension LibraryViewController {
    func getImportedItemGameInformation(for path: String) -> (String, String, String, String) {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB, .useKB]
        formatter.countStyle = .file
        
        var size: Int64 = 0
        do {
            size = try FileManager.default.attributesOfItem(atPath: path)[.size] as? Int64 ?? 0
        } catch { print(error.localizedDescription) }
        
        
        return (citraWrapper.getPublisher(path), citraWrapper.getRegion(path), formatter.string(fromByteCount: size), citraWrapper.getTitle(path))
    }
    
    
    func prepareAndDisplayLibrary() {
        let importedItemCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ImportedItem> { cell, indexPath, itemIdentifier in
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = itemIdentifier.title
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
            contentConfiguration.secondaryText = "\(itemIdentifier.region), \(itemIdentifier.publisher)"
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = contentConfiguration
            
            cell.accessories = [
                UICellAccessory.label(text: itemIdentifier.size, options: .init(tintColor: .systemGreen))
            ]
        }
        
        let installedItemCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, InstalledItem> { cell, indexPath, itemIdentifier in
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = itemIdentifier.title
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
            contentConfiguration.secondaryText = "\(itemIdentifier.region), \(itemIdentifier.publisher)"
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = contentConfiguration
            
            cell.accessories = [
                UICellAccessory.label(text: itemIdentifier.size, options: .init(tintColor: .systemGreen))
            ]
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var contentConfiguration: UIListContentConfiguration
            if #available(iOS 15, *) {
               contentConfiguration = UIListContentConfiguration.extraProminentInsetGroupedHeader()
                contentConfiguration.text = self.dataSource.sectionIdentifier(for: indexPath.section) ?? "Invalid Section"
            } else {
               contentConfiguration = UIListContentConfiguration.groupedHeader()
                contentConfiguration.text = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            }
            
            supplementaryView.contentConfiguration = contentConfiguration
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch (itemIdentifier) {
            case let importedItem as ImportedItem:
                return collectionView.dequeueConfiguredReusableCell(using: importedItemCellRegistration, for: indexPath, item: importedItem)
            case let installedItem as InstalledItem:
                return collectionView.dequeueConfiguredReusableCell(using: installedItemCellRegistration, for: indexPath, item: installedItem)
            default:
                return nil
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
        
        
        snapshot = NSDiffableDataSourceSnapshot()
        snapshot.appendSections(["Imported", "Installed"])
        snapshot.appendItems(citraWrapper.importedCIAs().reduce(into: [ImportedItem](), { partialResult, filePath in
            partialResult.append(ImportedItem(gameInfo: self.getImportedItemGameInformation(for: filePath)))
        }), toSection: "Imported")
        if #available(iOS 15, *) {
            Task {
                await dataSource.apply(snapshot)
            }
        } else {
            dataSource.apply(snapshot)
        }
    }
}
