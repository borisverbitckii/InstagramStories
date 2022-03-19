//
//  StateView.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit.UIView

enum StateViewType {
    case noStories
    case noSearchResults
    case noRecents
    case noFavorites
    case isPrivate
}

final class StateView: UIView {

    // MARK: - Public properties
    var type: StateViewType? {
        didSet {
            guard let type = type else { return }
            setupSelf(type: type)
        }
    }

    // MARK: - Private properties
    private let label: UILabel = {
        $0.font = Fonts.avenir(.heavy).getFont(size: .medium)
        return $0
    }(UILabel())

    private let secondaryLabel: UILabel = {
        $0.font = Fonts.avenir(.light).getFont(size: .small)
        $0.textColor = Palette.lightGray.color
        return $0
    }(UILabel())

    private let image: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    // MARK: - Init
    init(type: StateViewType) {
        super.init(frame: .zero)
        backgroundColor = Palette.clear.color
        addSubviews()
        setupSelf(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    // MARK: - Private methods
    private func setupSelf(type: StateViewType) {
        switch type {
        case .noStories:
            image.image = Images.stateView(.noStories).getImage()
            label.text = Text.stateViewMain(.noStories).getText()
            secondaryLabel.text = Text.stateViewSecondary(.noStories).getText()
        case .noSearchResults:
            image.image = Images.stateView(.noSearchResults).getImage()
            label.text = Text.stateViewMain(.noSearchResults).getText()
            secondaryLabel.text = Text.stateViewSecondary(.noSearchResults).getText()
        case .isPrivate:
            image.image = Images.stateView(.isPrivate).getImage()
            label.text = Text.stateViewMain(.isPrivate).getText()
            secondaryLabel.text = Text.stateViewSecondary(.isPrivate).getText()
        case .noRecents:
            image.image = Images.stateView(.noRecents).getImage()
            label.text = Text.stateViewMain(.noRecents).getText()
            secondaryLabel.text = Text.stateViewSecondary(.noRecents).getText()
        case .noFavorites:
            image.image = Images.stateView(.noFavorites).getImage()
            label.text = Text.stateViewMain(.noFavorites).getText()
            secondaryLabel.text = Text.stateViewSecondary(.noFavorites).getText()
        }

        label.textColor = Palette.purple.color
        layout()
    }

    private func addSubviews() {
        addSubview(image)
        addSubview(label)
        addSubview(secondaryLabel)
    }

    private func layout() {
        image.pin
            .size(LocalConstants.imageSize)
            .top(LocalConstants.imageTopInset)
            .hCenter()

        label.pin
            .below(of: image, aligned: .center).marginBottom(LocalConstants.labelTopInset)

        secondaryLabel.pin
            .below(of: label, aligned: .center).marginBottom(LocalConstants.secondaryLabelTopInset)

        label.sizeToFit()
        secondaryLabel.sizeToFit()

        let viewHeight = image.frame.height + label.frame.height + secondaryLabel.frame.height + LocalConstants.labelTopInset + LocalConstants.secondaryLabelTopInset
        pin.size(CGSize(width: image.frame.width, height: viewHeight))
    }
}

private enum LocalConstants {
    static let labelTopInset: CGFloat = 16
    static let secondaryLabelTopInset: CGFloat = 16
    static let imageSize = CGSize(width: 350, height: 350)
    static let imageTopInset: CGFloat = 16
}
