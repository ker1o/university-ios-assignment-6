//
//  CustomTableViewCell.swift
//  PasswordManager
//
//  Created by Kirill Asyamolov on 20/01/17.
//  Copyright © 2017 Kirill Asyamolov. All rights reserved.
//

import UIKit

class TwoColumnsTableViewCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value2, reuseIdentifier: reuseIdentifier)
    }
    
}
