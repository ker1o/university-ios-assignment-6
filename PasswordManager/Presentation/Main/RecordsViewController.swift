//
//  MyViewController.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 18/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {

    let defaultFileNameForLocalStore = "awesomeFileName.dat"
    let reusableCellID = "ReusableCellID"
    
    @IBOutlet weak var tableView: UITableView!
    
    // lazy initialization of RecordsManager instance
    fileprivate lazy var recordsManager: RecordsManager = {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURLForLocalStore = documentDirectoryURL!.appendingPathComponent(self.defaultFileNameForLocalStore)
        return RecordsManager(url: fileURLForLocalStore, preferences: Preferences.standard)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableCellID)
    }
    
    // MARK: Actions
    @IBAction func didTouchAddBarButtonItem(_ sender: AnyObject) {
        let rootViewController = RecordViewController(passwordStrength: Preferences.standard.passwordStrength)
        rootViewController.delegate = self
        
        let navigationController = UINavigationController.init(rootViewController: rootViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func didTouchSettingsBarButtonItem(_ sender: AnyObject) {
        let rootViewController = SettingsViewController(preferences: Preferences.standard)
        rootViewController.delegate = self
        
        let navigationController = UINavigationController.init(rootViewController: rootViewController)
        navigationController.navigationBar.isTranslucent = false
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension RecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordsManager.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: reusableCellID, for: indexPath)
        let record = recordsManager.records[indexPath.row]
        tableViewCell.textLabel?.text = record.value(forKey: Record.keyServiceName) as? String
        tableViewCell.detailTextLabel?.text = record.value(forKey: Record.keyPassword) as? String
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recordsManager.remove(record: recordsManager.records[indexPath.row])
            recordsManager.synchronyze()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension RecordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootViewController = RecordViewController(passwordStrength: Preferences.standard.passwordStrength)
        rootViewController.delegate = self
        rootViewController.record = recordsManager.records[indexPath.row]
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.isTranslucent = false
        present(navigationController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension RecordsViewController: RecordViewControllerDelegate {
    func recordViewController(_ recordViewController: RecordViewController, didFinishWith record: NSDictionary?) {
        if let newRecord = record {
            if let oldRecord = recordViewController.record {
                recordsManager.replace(record: oldRecord, withRecord: newRecord)
            } else {
                recordsManager.register(record: newRecord)
            }
            recordsManager.synchronyze()
            
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension RecordsViewController: SettingsViewControllerDelegate {
    func settingsViewControllerDidFinish(sender: SettingsViewController) {
        recordsManager.synchronyze()
        dismiss(animated: true, completion: nil)
    }
}
