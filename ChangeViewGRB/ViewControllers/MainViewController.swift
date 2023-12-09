//
//  MainViewController.swift
//  ChangeViewGRB
//
//  Created by Alexey Solop on 08.12.2023.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func updateColor(color: UIColor)
}

final class MainViewController: UIViewController {
    var viewColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewColorFromBackgroundColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsViewController = segue.destination as? SettingsViewController else { return }
        guard let color = viewColor else { return }
        
        settingsViewController.delegate = self
        settingsViewController.color = color
    }
    
    @IBAction func openSettingsViewController() {
        updateViewColorFromBackgroundColor()
        performSegue(withIdentifier: "ToSettingsVC", sender: nil)
    }
    
    private func updateViewColorFromBackgroundColor() {
        guard let color = view.backgroundColor else { return }
        self.viewColor = color
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: MainViewControllerDelegate {
    func updateColor(color: UIColor) {
        view.backgroundColor = color
    }
}
