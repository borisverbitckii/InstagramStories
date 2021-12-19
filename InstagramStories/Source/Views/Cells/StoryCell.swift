//
//  StoryCell.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import UIKit

final class StoryCell: UICollectionViewCell {
    
    //MARK: - Private properties
    private var activityIndicator: CustomActivityIndicator = {
        $0.type = .defaultActivityIndicator(.medium)
        $0.show()
        return $0
    }(CustomActivityIndicator())
    
    private var storyImage: UIImageView = {
        $0.layer.cornerRadius = LocalConstants.cornerRadius
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.hide()
    }
    
    //MARK: - Public methods
    func configure() {
        activityIndicator.show()
    }
    
    //MARK: - Private methods
    private func setupSelf() {
        backgroundColor = Palette.white.color
        layer.cornerRadius = LocalConstants.cornerRadius
        Utils.addShadow(type: .shadowIsUnder, layer: layer)
    }
    
    private func addSubviews() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(storyImage)
    }
    
    private func layout() {
        activityIndicator.pin
            .center()
        
        storyImage.frame = contentView.frame
    }
}

private enum LocalConstants {
    static let cornerRadius: CGFloat = 20
}
