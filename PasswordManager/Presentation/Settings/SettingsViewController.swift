//
//  SettingsViewController.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 25/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let keyPasswordStrengthSectionTitle = "Password strength"
    let keyPasswordStorageSectionTitle = "Password storage"
   
    let dataPasswordStrength = ["Weak", "Medium", "Strong"]
    let dataPasswordStorage = ["Property list", "SQLite"]
    
    let reusableCellID = "reusableCellID"

    var delegate: SettingsViewControllerDelegate?
    
    var checkedIndexPasswordStrength: IndexPath
    var checkedIndexPasswordStorage: IndexPath
    
    //we have to set this parameter in init
    var preferences: Preferences
    
    init(preferences: Preferences) {
        self.preferences = preferences
        
        switch self.preferences.passwordStrength {
        case .weak:
            checkedIndexPasswordStrength = IndexPath(row: 0, section: 0)
        case .medium:
            checkedIndexPasswordStrength = IndexPath(row: 1, section: 0)
        case .strong:
            checkedIndexPasswordStrength = IndexPath(row: 2, section: 0)
        }
        
        switch Preferences.standard.passwordStorage {
        case .propertyList:
            checkedIndexPasswordStorage = IndexPath(row: 0, section: 1)
        case .sqLite:
            checkedIndexPasswordStorage = IndexPath(row: 1, section: 1)
        }
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTouchDoneBarButton))
        //how to correctly check that we have Navigation Controller?
        navigationItem.setRightBarButton(doneBarButton, animated: false)
    }
    
    func update(passwordStrength: Preferences.PasswordStrength) {
        preferences.passwordStrength = passwordStrength
    }
    
    func update(passwordStorage: Preferences.PasswordStorage) {
        preferences.passwordStorage = passwordStorage
    }

    func didTouchDoneBarButton() {
        switch checkedIndexPasswordStrength.row {
        case 2:
            update(passwordStrength: .strong)
        case 1:
            update(passwordStrength: .medium)
        default:
            update(passwordStrength: .weak)
        }
        
        switch checkedIndexPasswordStorage.row {
        case 1:
            update(passwordStorage: .sqLite)
        default:
            update(passwordStorage: .propertyList)
        }
        
        delegate?.settingsViewControllerDidFinish(sender: self)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dataPasswordStrength.count : dataPasswordStorage.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return keyPasswordStrengthSectionTitle
        } else {
            return keyPasswordStorageSectionTitle
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableCellID)
        if tableViewCell == nil {
            tableViewCell = UITableViewCell(style: .default, reuseIdentifier: reusableCellID)
        }
        
        if indexPath.section == 0{
            tableViewCell.textLabel?.text = dataPasswordStrength[indexPath.row]
            tableViewCell.accessoryType = (indexPath.row == checkedIndexPasswordStrength.row ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none)
        } else {
            tableViewCell.textLabel?.text = dataPasswordStorage[indexPath.row]
            tableViewCell.accessoryType = (indexPath.row == checkedIndexPasswordStorage.row ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none)
            
        }
        
        return tableViewCell
    }
    
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var oldIndexPath: IndexPath?
        if indexPath.section == 0 {
            if indexPath.row == checkedIndexPasswordStrength.row {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            oldIndexPath = checkedIndexPasswordStrength
            checkedIndexPasswordStrength = indexPath
        } else {
            if indexPath.row == checkedIndexPasswordStorage.row {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            oldIndexPath = checkedIndexPasswordStorage
            checkedIndexPasswordStorage = indexPath
        }
        
        tableView.reloadRows(at: [oldIndexPath!, indexPath], with: UITableViewRowAnimation.none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
