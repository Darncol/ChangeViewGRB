//
//  MainViewController.swift
//  ChangeViewGRB
//
//  Created by Alexey Solop on 08.12.2023.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updateColor(color: UIColor)
}

final class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsViewController = segue.destination as? SettingsViewController else { return }
        
        settingsViewController.delegate = self
        settingsViewController.color = view.backgroundColor
    }
}

// MARK: - Delegate
extension MainViewController: SettingsViewControllerDelegate {
    func updateColor(color: UIColor) {
        view.backgroundColor = color
    }
}
