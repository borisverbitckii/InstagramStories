//
//  InstagramUserCell.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UITableViewCell
import UIKit.UIImageView
import UIKit.UIButton

enum InstagramUserCellType {
    case remove
    case addToFavorites
}
    
final class InstagramUserCell: UITableViewCell {
    
    //MARK: - Private properties
    private let userIcon: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private let nickNameLabel: UILabel = {
        $0.font = Fonts.instagramCellNickname.getFont()
        $0.textColor = .gray
        return $0
    }(UILabel())
    
    private let nameLabel: UILabel = {
        $0.font = Fonts.instagramCellName.getFont()
        return $0
    }(UILabel())
    
    private let stackViewForText: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        return $0
    }(UIStackView())
    
    private let trailingButton: UIButton = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIButton())
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
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
    func configure(type: InstagramUserCellType,user: InstagramUser) {
        switch type {
        case .remove:
            trailingButton.setImage(Images.trailingCellButton(.remove).getImage(),
                                    for: .normal)
        case .addToFavorites:
            trailingButton.setImage(Images.trailingCellButton(.addToFavorites).getImage(),
                                    for: .normal)
        }
        nameLabel.text = user.name
        nickNameLabel.text = "@" + user.instagramUsername
        userIcon.image = UIImage(data: user.userIcon)
    }
    
    //MARK: - Private methods
    private func addSubviews(){
        stackViewForText.addArrangedSubview(nameLabel)
        stackViewForText.addArrangedSubview(nickNameLabel)
        contentView.addSubview(stackViewForText)
        contentView.addSubview(trailingButton)
        contentView.addSubview(userIcon)
    }
    
    private func layout() {
        userIcon.pin
            .left(LocalConstants.horizontalInset)
            .vCenter()
            .size(LocalConstants.userIconSize)
        
        trailingButton.pin
            .right(LocalConstants.horizontalInset)
            .size(LocalConstants.deleteButtonSize)
            .vCenter()
        
        stackViewForText.pin
            .after(of: userIcon).margin(20)
            .before(of: trailingButton)
            .width(100)
            .vCenter()
            .height(contentView.frame.height - 30)
        
    }
}

private enum LocalConstants {
    //Sizes and insets
    static let horizontalInset: CGFloat = 16
    static let userIconSize = CGSize(width: 50 , height: 50)
    static let deleteButtonSize = CGSize(width: 30, height: 30)
}
