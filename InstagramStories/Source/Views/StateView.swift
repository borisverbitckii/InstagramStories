//
//  StateView.swift
//  InstagramStories
//
//  Created by Борис on 21.12.2021.
//

import UIKit.UIView
import UIKit

enum StateViewType {
    case noStories
    case noSearchResults
    case isPrivate
}


final class StateView: UIView {
    
    //MARK: - Public properties
    var type: StateViewType? {
        didSet {
            guard let type = type else { return }
            setupSelf(type: type)
        }
    }
    
    //MARK: - Private properties
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
        $0.backgroundColor = Palette.superLightGray.color
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    //MARK: - Init
    init(type: StateViewType) {
        super.init(frame: .zero)
        backgroundColor = Palette.clear.color
        addSubviews()
        setupSelf(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    //MARK: - Private methods
    private func setupSelf(type: StateViewType) {
        switch type {
        case .noStories:
            image.image = UIImage(systemName: "heart")
            label.text = Text.noStories.getText()
            secondaryLabel.text = Text.tryLatter.getText()
        case .noSearchResults:
            image.image = UIImage(systemName: "heart")
            label.text = Text.noSearchResult.getText()
            secondaryLabel.text = Text.tryAgain.getText()
        case .isPrivate:
            image.image = UIImage(systemName: "heart")
            label.text = Text.isPrivate.getText()
            secondaryLabel.text = ""
        }
        layout()
    }
    
    private func addSubviews() {
        addSubview(image)
        addSubview(label)
        addSubview(secondaryLabel)
    }
    
    private func layout() {
        pin.size(LocalConstants.noSearchResultSize)
        
        image.pin
            .size(LocalConstants.imageSize)
            .top(LocalConstants.imageTopInset)
            .hCenter()
        
        secondaryLabel.pin
            .bottom(LocalConstants.secondaryLabelBottomInset)
            .hCenter()
        
        label.pin
            .above(of: secondaryLabel).marginTop(LocalConstants.labelBottomInset)
            .hCenter()
        
        label.sizeToFit()
        secondaryLabel.sizeToFit()
    }
}

private enum LocalConstants {
    static let noSearchResultCornerRadius: CGFloat = 30
    static let noSearchResultSize = CGSize(width: 200, height: 200)
    static let secondaryLabelBottomInset: CGFloat = 30
    static let labelBottomInset: CGFloat = 30
    static let imageSize = CGSize(width: 100, height: 100)
    static let imageTopInset: CGFloat = 16
}
