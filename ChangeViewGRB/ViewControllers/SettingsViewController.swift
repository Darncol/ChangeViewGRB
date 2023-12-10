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
    
    var color: UIColor!
    
    weak var delegate : SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        initializeSlidersWithColor()
        updateColorValueTextFields()
        registerForKeyboardEvents()
        signTextFiledsForDelegate()
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
    
    private func signTextFiledsForDelegate() {
        redTextField.delegate = self
        greenTextFiled.delegate = self
        blueTextFiled.delegate = self
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
    
    func updateColorValueTextFields() {
        redTextField.text = formatSliderValue(redColorSlider.value)
        greenTextFiled.text = formatSliderValue(greenColorSlider.value)
        blueTextFiled.text = formatSliderValue(blueColorSlider.value)
    }
    
    func formatSliderValue(_ value: Float) -> String {
        String(format: "%.2f", value)
    }
    
    func initializeSlidersWithColor() {
        colorDisplayView.backgroundColor = color
        
        var ciColor = CIColor(color: color)
        
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
                  return
              }
        
        switch textField.tag {
        case 0:
            redColorSlider.setValue(number, animated: true)
        case 1:
            greenColorSlider.setValue(number, animated: true)
        default:
            blueColorSlider.setValue(number, animated: true)
        }
        updateColorDisplay()
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
