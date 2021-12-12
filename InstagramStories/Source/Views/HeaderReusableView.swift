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
        $0.font =  Fonts.searchHeader.getFont()
        return $0
    }(UILabel())
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    func configure(title: String) {
        titleLabel.text = title
        layout()
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func layout() {
        titleLabel.pin
            .left(LocalConstants.titleLeftInset)
            .vCenter()
            .sizeToFit()
    }
}

private enum LocalConstants {
    static let titleLeftInset: CGFloat = 32
    static let shadowContainerLeftInset: CGFloat = 16
    static let shadowContainerRightInset: CGFloat = 16
    static let headerCornerRadius: CGFloat = 20
}
