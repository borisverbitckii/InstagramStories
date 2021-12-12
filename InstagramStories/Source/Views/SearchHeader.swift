//
//  SearchHeader.swift
//  InstagramStories
//
//  Created by Борис on 12.12.2021.
//

import UIKit

final class SearchHeader: UITableViewHeaderFooterView {
    
    //MARK: - Private properties
    private let titleLabel : UILabel = {
        $0.font =  Fonts.searchHeader.getFont()
        return $0
    }(UILabel())
    
    private let containerShadowView: UIView = {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        Utils.addShadow(type: .navBar, layer: layer)
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
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        contentView.addSubview(containerShadowView)
        containerShadowView.addSubview(titleLabel)
    }
    
    private func layout() {
        titleLabel.pin
            .left(LocalConstants.titleLeftInset)
            .vCenter()
            .sizeToFit()
        
        containerShadowView.pin
            .left(LocalConstants.shadowContainerLeftInset)
            .right(LocalConstants.shadowContainerRightInset)
            .top()
            .bottom()
    }
}

private enum LocalConstants {
    static let titleLeftInset: CGFloat = 16
    static let shadowContainerLeftInset: CGFloat = 16
    static let shadowContainerRightInset: CGFloat = 16
}
