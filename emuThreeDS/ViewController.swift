//
//  ViewController.swift
//  emuThreeDS
//
//  Created by Antique on 14/6/2023.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialLayout()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Under Construction", attributes: [
            .font : UIFont.preferredFont(forTextStyle: .title1),
            .foregroundColor : UIColor.secondaryLabel
        ])
        view.addSubview(label)
        view.addConstraints([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    fileprivate func configureInitialLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "emuThreeDS"
        view.backgroundColor = .systemBackground
    }
}
