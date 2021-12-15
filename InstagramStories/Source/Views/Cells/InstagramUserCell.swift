//
//  InstagramUserCell.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UICollectionViewCell
import UIKit.UIImageView
import UIKit.UIButton

enum InstagramUserCellType {
    case fromDB
    case fromNetwork
}

protocol InstagramUserCellButtonDelegate {
    func trailingButtonTapped(type: InstagramUserCellType)
}

protocol InstagramUserCellImageDelegate {
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage,Error>)->())
}

final class InstagramUserCell: UICollectionViewCell {
    
    //MARK: - Public properties
    var buttonDelegate: InstagramUserCellButtonDelegate?
    var imageDelegate: InstagramUserCellImageDelegate?
    
    //MARK: - Private properties
    private var type: InstagramUserCellType?
    private var activityIndicator: CustomActivityIndicator = {
        $0.type = .defaultActivityIndicator(.medium)
        $0.hide()
        return $0
    }(CustomActivityIndicator())
    
    private let userIcon: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let nickNameLabel: UILabel = {
        $0.font = Fonts.instagramCellNickname.getFont()
        $0.textColor = Palette.gray.color
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
        $0.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        backgroundColor = Palette.white.color
        layer.cornerRadius = LocalConstants.cellCornerRadius
        Utils.addShadow(type: .shadowIsUnder, layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        type = nil
        trailingButton.setImage(UIImage(), for: .normal)
        userIcon.image = nil
        nameLabel.text = ""
        nickNameLabel.text = ""
    }
    
    //MARK: - Public methods
    func configure(type: InstagramUserCellType,user: InstagramUser) {
        self.type = type
        
        nameLabel.text = user.name
        nickNameLabel.text = "@" + user.instagramUsername
        
        switch type {
        case .fromDB:
            trailingButton.setImage(Images.trailingCellButton(.fromDB).getImage(),
                                    for: .normal)
            userIcon.image = Images.userImageIsEmpty.getImage()
            activityIndicator.hide()
        case .fromNetwork:
            trailingButton.setImage(Images.trailingCellButton(.fromNetwork).getImage(),
                                    for: .normal)

            if ImageCacheManager.isAlreadyCached(stringURL: user.userIconURL) {
                activityIndicator.hide()
                fetchImage(for: user)
            } else {
                activityIndicator.show()
                fetchImage(for: user)
            }
        }
    }
    
    //MARK: - Private methods
    private func fetchImage(for user: InstagramUser) {
        let queue = DispatchQueue(label: "image", qos: .userInteractive)
        
        queue.async { [weak self] in
            self?.imageDelegate?.fetchImage(stringURL: user.userIconURL, completion: { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.activityIndicator.hide()
                        UIView.transition(with: self.userIcon,
                                          duration: LocalConstants.animationDuration,
                                          options: .transitionCrossDissolve,
                                          animations: {
                            self.userIcon.image = image })
                    }
                case .failure(_):
                    //TODO: Change this
                    break
                }
            })
        }
    }
    
    private func addSubviews(){
        stackViewForText.addArrangedSubview(nameLabel)
        stackViewForText.addArrangedSubview(nickNameLabel)
        contentView.addSubview(stackViewForText)
        contentView.addSubview(trailingButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(userIcon)
    }
    
    private func layout() {
        userIcon.pin
            .left(LocalConstants.horizontalInset)
            .vCenter()
            .size(LocalConstants.userIconSize)
        
        activityIndicator.frame = userIcon.frame
        
        userIcon.layer.cornerRadius = userIcon.frame.height / 2
        
        trailingButton.pin
            .right(LocalConstants.horizontalInset)
            .size(LocalConstants.deleteButtonSize)
            .vCenter()
        
        stackViewForText.pin
            .after(of: userIcon).margin(LocalConstants.stackViewLeadingInset)
            .before(of: trailingButton)
            .vCenter()
            .height(contentView.frame.height - 30)
        
    }
    
    //MARK: - OBJC methods
    @objc private func trailingButtonTapped() {
        if let type = type {
            buttonDelegate?.trailingButtonTapped(type: type)
        }
    }
}

private enum LocalConstants {
    //Sizes and insets
    static let horizontalInset: CGFloat = 16
    static let userIconSize = CGSize(width: 50 , height: 50)
    static let deleteButtonSize = CGSize(width: 30, height: 30)
    static let stackViewLeadingInset: CGFloat = 20
    static let cellCornerRadius: CGFloat = 35
    
    static let animationDuration: TimeInterval = 0.45
}
