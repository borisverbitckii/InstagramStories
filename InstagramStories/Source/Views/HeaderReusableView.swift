//
//  SearchHeader.swift
//  InstagramStories
//
//  Created by Борис on 12.12.2021.
//

import UIKit

final class HeaderReusableView: UICollectionReusableView {
    
    //MARK: - Private properties
    private let titleLabel : UILabel = {
        $0.font = Fonts.avenir(.book).getFont(size: .medium)
        $0.textColor = Palette.lightGray.color
        return $0
    }(UILabel())
    
    private let containerView: UIView = {
        $0.layer.cornerRadius = LocalConstants.headerCornerRadius
        $0.clipsToBounds = true
        $0.backgroundColor = Palette.white.color
        return $0
    }(UIView())
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        Utils.addShadow(type: .shadowIsBelow, layer: layer)
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
    func configure(title: String) {
        titleLabel.text = title
        layout()
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        containerView.addSubview(titleLabel)
        addSubview(containerView)
    }
    
    private func layout() {
        titleLabel.pin
            .left(LocalConstants.leftInset)
            .vCenter()
            .sizeToFit()
        
        containerView.pin
            .left(LocalConstants.leftInset)
            .top()
            .bottom()
            .width(titleLabel.intrinsicContentSize.width + 32)
    }
}

private enum LocalConstants {
    static let leftInset: CGFloat = 16
    static let shadowContainerLeftInset: CGFloat = 16
    static let shadowContainerRightInset: CGFloat = 16
    static let headerCornerRadius: CGFloat = 15
}
