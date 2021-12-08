//
//  SettingsCell.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit
import PinLayout

final class SettingsCell: UITableViewCell {
    
    //MARK: - Private properties
    private let settingName: UILabel = {
        $0.font = Fonts.instagramCellName.getFont()
        return $0
    }(UILabel())
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(settingName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    //MARK: - Public methods
    func configure(setting: Setting) {
        settingName.text = setting.name
    }
    
    private func layout() {
        settingName.pin
            .left(LocalConstants.leftLabelInset)
            .top()
            .bottom()
            .right(safeAreaInsets.right)
    }
}

private enum LocalConstants {
    static let leftLabelInset: CGFloat = 30
}
