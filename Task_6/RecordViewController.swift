//
//  NewRecordViewController.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 23/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITextFieldDelegate {
    
    let passwordLengthShort = 5
    let passwordLengthMedium = 10
    let passwordLengthLong = 15
    
    let lowercaseLetterAlphabet = "abcdefghijklmnopqrstuvwxyz"
    let uppercaseLetterAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let decimalDigitAlphabet = "1234567890"
    
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var serviceNameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var record: NSDictionary?
   
    var passwordStrength: Preferences.PasswordStrength
    var delegate: RecordViewControllerDelegate?
    
    init(passwordStrength: Preferences.PasswordStrength) {
        self.passwordStrength = passwordStrength
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: auxiliaries
    func refreshPassword() {
        var passwordLength = 0
        var alphabet = lowercaseLetterAlphabet
        switch Preferences.standard.passwordStrength {
        case .strong:
            passwordLength = passwordLengthLong
            alphabet = alphabet.appending(uppercaseLetterAlphabet).appending(decimalDigitAlphabet)
            
        case .medium:
            passwordLength = passwordLengthMedium
            alphabet = alphabet.appending(uppercaseLetterAlphabet)
            
        case .weak:
            passwordLength = passwordLengthShort
            break
        }
        
        passwordLabel.text = PasswordGenerator.generatePassword(ofLength: passwordLength, usingAlphabet: alphabet)
    }
    
    func saveRecord() {
        if serviceNameTextField.text != "" {
            let record: NSDictionary = [Record.keyServiceName: serviceNameTextField.text!, Record.keyPassword: passwordLabel.text!]
            delegate!.recordViewController(self, didFinishWith: record)
        }
    }
    
    // MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(didTouchCancelBarButtonItem))
        navigationItem.setLeftBarButton(cancelBarButton, animated: false)
        
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(didTouchSaveBarButtonItem))
        navigationItem.setRightBarButton(saveBarButton, animated: false)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let record = record {
            serviceNameTextField.text = record.object(forKey: Record.keyServiceName) as? String
            passwordLabel.text = record.object(forKey: Record.keyPassword) as? String
        }
     }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if record == nil {
            refreshPassword()
            serviceNameTextField.becomeFirstResponder()
        }
    }
    
    // MARK: Actions
    func didTouchCancelBarButtonItem() {
        delegate!.recordViewController(self, didFinishWith: nil)
    }
    
    func didTouchSaveBarButtonItem() {
        saveRecord()
    }
    
    @IBAction func didTouchRefreshButton(_ sender: AnyObject) {
        refreshPassword()
    }
    
    // MARK: UITextField delegate implementation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //saveRecord()
        textField.resignFirstResponder()
        return true
    }


}
