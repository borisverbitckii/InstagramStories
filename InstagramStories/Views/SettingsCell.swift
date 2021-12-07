//
//  SettingsCell.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UITableViewCell
import UIKit

final class SettingsCell: UITableViewCell {
    
    private let settingName: UILabel = {
        $0.font = Fonts.instagramCellName.getFont()
        return $0
    }(UILabel())
    
    //MARK: - Public methods
    func configure(setting: Setting) {
        settingName.text = setting.name
    }
}
