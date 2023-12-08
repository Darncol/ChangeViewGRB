//
//  MainViewController.swift
//  ChangeViewGRB
//
//  Created by Alexey Solop on 08.12.2023.
//

import UIKit

protocol MainViewControllerDelegate {
    func updateColor()
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    var viewColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateMainBackgroundColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsViewController = segue.destination as? SettingsViewController else { return }
        guard let color = viewColor else { return }
        
        settingsViewController.delegate = self
        settingsViewController.color = color
    }
    
    private func updateMainBackgroundColor() {
        guard let viewColor = mainView.backgroundColor else { return }
        self.viewColor = viewColor
    }

}

extension MainViewController: MainViewControllerDelegate {
    func updateColor() {
        updateMainBackgroundColor()
    }
}
