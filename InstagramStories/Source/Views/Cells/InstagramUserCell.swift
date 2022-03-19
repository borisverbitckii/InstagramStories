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
    case removeFromRecent
    case favorite(FavoriteButtonType? = nil)
}

enum FavoriteButtonType {
    case add
    case remove
}

protocol InstagramUserCellButtonDelegate: AnyObject {
    func trailingButtonTapped(type: InstagramUserCellType, user: RealmInstagramUserProtocol)
}

protocol InstagramUserCellImageDelegate: AnyObject {
    func userImageWillBeShown(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class InstagramUserCell: UICollectionViewCell {

    // MARK: - Public properties
    weak var buttonDelegate: InstagramUserCellButtonDelegate?
    weak var imageDelegate: InstagramUserCellImageDelegate?

    // MARK: - Private properties
    private var type: InstagramUserCellType? {
        didSet {
            switch type {
            case .removeFromRecent:
                trailingButton.setImage(Images.trailingCellButton(.removeFromRecent).getImage(),
                                        for: .normal)
                activityIndicator.hide()
            case .favorite(let favoriteType):
                switch favoriteType {
                case .add:
                    trailingButton.setImage(Images.trailingCellButton(.favorite(.add)).getImage(),
                                            for: .normal)
                case .remove:
                    trailingButton.setImage(Images.trailingCellButton(.favorite(.remove)).getImage(),
                                            for: .normal)
                case .none:
                    break
                }
            case .none: break
            }
            trailingButton.tintColor = Palette.purple.color
        }
    }
    private var user: RealmInstagramUserProtocol?
    private var defaultButtonState = true

    // UIElements
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
        $0.font = Fonts.avenir(.light).getFont(size: .small)
        $0.textColor = Palette.gray.color
        return $0
    }(UILabel())

    private let nameLabel: UILabel = {
        $0.font = Fonts.avenir(.heavy).getFont(size: .medium)
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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        backgroundColor = Palette.white.color
        layer.cornerRadius = LocalConstants.cellCornerRadius
        Utils.addShadow(type: .shadowIsBelow, layer: layer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods
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

    // MARK: - Public methods
    func configure(type: InstagramUserCellType, user: RealmInstagramUserProtocol) {
        self.type = type
        self.user = user

        nameLabel.text = user.name
        nickNameLabel.text = "@" + user.instagramUsername
        trailingButton.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)

        ImageCacheManager.isAlreadyCached(stringURL: user.userIconURL)
            ? activityIndicator.hide()
            : activityIndicator.show()

        fetchImage(for: user)
    }

    // MARK: - Private methods
    private func fetchImage(for user: RealmInstagramUserProtocol) {
        self.imageDelegate?.userImageWillBeShown(stringURL: user.userIconURL, completion: { result in
            switch result {
            case .success(let image):
                self.activityIndicator.hide()
                UIView.transition(with: self.userIcon,
                                  duration: LocalConstants.animationDuration,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.userIcon.image = image })

            case .failure(let error):
                print(error)
                break
            }
        })
    }

    private func addSubviews() {
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
            .height(contentView.frame.height * 0.6)

    }

    private func changeButtonImage() {
        defaultButtonState.toggle()

        switch type {
        case .favorite(let favoriteType):
            switch favoriteType {
            case .add:
                type = .favorite(.remove)
            case .remove:
                type = .favorite(.add)
            case .none:
                break
            }
        case .removeFromRecent, .none: break
        }
    }

    // MARK: - OBJC methods
    @objc private func trailingButtonTapped() {
        if let type = type, let user = user {
            changeButtonImage()
            buttonDelegate?.trailingButtonTapped(type: type, user: user)
        }
    }
}

private enum LocalConstants {
    // Sizes and insets
    static let horizontalInset: CGFloat = 16
    static let userIconSize = CGSize(width: 50, height: 50)
    static let deleteButtonSize = CGSize(width: 30, height: 30)
    static let stackViewLeadingInset: CGFloat = 20
    static let cellCornerRadius: CGFloat = 35

    static let animationDuration: TimeInterval = 0.45
}
