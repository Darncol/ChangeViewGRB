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
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextFiled: UITextField!
    @IBOutlet weak var blueTextFiled: UITextField!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    
    var color: UIColor!
    
    weak var delegate : SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        initializeSlidersWithColor()
        updateColorValueTextFields()
        registerForKeyboardEvents()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        colorDisplayView.layer.cornerRadius = colorDisplayView.frame.height / 2
    }
    
    @IBAction func saveButtonTapped() {
        view.endEditing(true)
        guard let backgroundColor = colorDisplayView.backgroundColor else { return }
        delegate?.updateColor(color: backgroundColor)
        dismiss(animated: true)
    }
    
    @IBAction func sliderValueChanged() {
        updateColorDisplay()
        updateColorValueTextFields()
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
    
    func updateColorValueTextFields(sliders: UISlider...) {
        redTextField.text = formatSliderValue(redColorSlider.value)
        greenTextFiled.text = formatSliderValue(greenColorSlider.value)
        blueTextFiled.text = formatSliderValue(blueColorSlider.value)
        
        redLabel.text = redTextField.text
        greenLabel.text = greenTextFiled.text
        blueLabel.text = blueTextFiled.text
    }
    
    func formatSliderValue(_ value: Float) -> String {
        String(format: "%.2f", value)
    }
    
    func initializeSlidersWithColor() {
        colorDisplayView.backgroundColor = color
        
        let ciColor = CIColor(color: color)
        
        redColorSlider.value = Float(ciColor.red)
        greenColorSlider.value = Float(ciColor.green)
        blueColorSlider.value = Float(ciColor.blue)
    }
}

// MARK: - Text Field Delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              let number = Float(text),
              (0.0...1.0).contains(number) else {
            showAlert(
                title: "Wrong format",
                message: "Please enter value from 0.0 to 1.0"
            )
            textField.text = getOldValue(from: textField.tag)
            return
        }
        
        switch textField.tag {
        case 0:
            redColorSlider.setValue(number, animated: true)
            redLabel.text = number.formatted()
        case 1:
            greenColorSlider.setValue(number, animated: true)
            greenLabel.text = number.formatted()
        default:
            blueColorSlider.setValue(number, animated: true)
            blueLabel.text = number.formatted()
        }
        updateColorDisplay()
    }
    
    private func getOldValue(from label: Int) -> String {
        switch label {
        case 0:
            redLabel.text ?? "0"
        case 1:
            greenLabel.text ?? "0"
        default:
            blueLabel.text ?? "0"
        }
    }
}

// MARK: - keyboard
extension SettingsViewController {
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar()
        
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        redTextField.inputAccessoryView = doneToolbar
        greenTextFiled.inputAccessoryView = doneToolbar
        blueTextFiled.inputAccessoryView = doneToolbar
    }
    
    private func registerForKeyboardEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (
            (
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            )?.cgRectValue
        ) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @objc func doneButtonAction() {
        view.endEditing(true)
    }
}

extension SettingsViewController {
    func showAlert(title: String, message: String, closure: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            closure?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
