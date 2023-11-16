//
//  ViewController.swift
//  ChangeViewGRB
//
//  Created by Alexey Solop on 16.11.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var colorDisplayView: UIView!
    
    @IBOutlet weak var redColorSlider: UISlider!
    @IBOutlet weak var greenColorSlider: UISlider!
    @IBOutlet weak var blueColorSlider: UISlider!
    
    @IBOutlet weak var redColorValueLabel: UILabel!
    @IBOutlet weak var greenColorValueLabel: UILabel!
    @IBOutlet weak var blueColorValueLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColorDisplay()
        updateColorValueLabels()
    }
    
    override func viewWillLayoutSubviews() {
        colorDisplayView.layer.cornerRadius = colorDisplayView.frame.height / 2
    }
    
    @IBAction func sliderValueChanged() {
        updateColorDisplay()
        updateColorValueLabels()
    }
    
    private func updateColorDisplay() {
        colorDisplayView.backgroundColor = UIColor(
            red: CGFloat(redColorSlider.value),
            green: CGFloat(greenColorSlider.value),
            blue: CGFloat(blueColorSlider.value),
            alpha: 1
        )
    }
    
    private func updateColorValueLabels() {
        redColorValueLabel.text = formatSliderValue(redColorSlider.value)
        greenColorValueLabel.text = formatSliderValue(greenColorSlider.value)
        blueColorValueLabel.text = formatSliderValue(blueColorSlider.value)
    }
    
    private func formatSliderValue(_ value: Float) -> String {
        String(format: "%.2f", value)
    }
}

