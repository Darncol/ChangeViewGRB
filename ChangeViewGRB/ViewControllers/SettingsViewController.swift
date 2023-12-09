//
//  ViewController.swift
//  ChangeViewGRB
//
//  Created by Alexey Solop on 16.11.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak var colorDisplayView: UIView!
    
    @IBOutlet weak var redColorSlider: UISlider!
    @IBOutlet weak var greenColorSlider: UISlider!
    @IBOutlet weak var blueColorSlider: UISlider!
    
    @IBOutlet weak var redColorValueLabel: UILabel!
    @IBOutlet weak var greenColorValueLabel: UILabel!
    @IBOutlet weak var blueColorValueLabel: UILabel!
    
    var color: UIColor!
    
    weak var delegate : MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSlidersWithColor()
        updateColorValueLabels()
    }
    
    override func viewWillLayoutSubviews() {
        colorDisplayView.layer.cornerRadius = colorDisplayView.frame.height / 2
    }
    
    @IBAction func saveButtonTapped() {
        guard let backgroundColor = colorDisplayView.backgroundColor else { return }
        delegate?.updateColor(color: backgroundColor)
        dismiss(animated: true)
    }
    
    @IBAction func sliderValueChanged() {
        updateColorDisplay()
        updateColorValueLabels()
    }
}

// MARK: Color Update Methods
private extension SettingsViewController {
    func updateColorDisplay() {
        colorDisplayView.backgroundColor = UIColor(
            red: CGFloat(redColorSlider.value),
            green: CGFloat(greenColorSlider.value),
            blue: CGFloat(blueColorSlider.value),
            alpha: 1
        )
    }
    
    func updateColorValueLabels() {
        redColorValueLabel.text = formatSliderValue(redColorSlider.value)
        greenColorValueLabel.text = formatSliderValue(greenColorSlider.value)
        blueColorValueLabel.text = formatSliderValue(blueColorSlider.value)
    }
    
    func formatSliderValue(_ value: Float) -> String {
        String(format: "%.2f", value)
    }
    
    func initializeSlidersWithColor() {
        guard let color = color else { return }
        colorDisplayView.backgroundColor = color
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        redColorSlider.value = Float(red)
        greenColorSlider.value = Float(green)
        blueColorSlider.value = Float(blue)
    }
}

