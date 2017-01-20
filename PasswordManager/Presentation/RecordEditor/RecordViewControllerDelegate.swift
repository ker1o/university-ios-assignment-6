//
//  NewRecordViewControllerDelegate.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 23/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import Foundation

protocol RecordViewControllerDelegate {
    func recordViewController(_ recordViewController: RecordViewController, didFinishWith record: Record?)
}
