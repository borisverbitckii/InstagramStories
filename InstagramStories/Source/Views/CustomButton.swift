//
//  ScrollToTopButton.swift
//  InstagramStories
//
//  Created by Борис on 14.12.2021.
//

import UIKit

enum CustomButtonType {
    case scroll
}

final class CustomButton : UIButton {
    
    //MARK: - Private methods
    private let button: UIView = {
        $0.clipsToBounds = true
        $0.backgroundColor = Palette.white.color
        return $0
    }(UIImageView())
    
    private let buttonImage: UIImageView = {
        return $0
    }(UIImageView())
    
    //MARK: - Init
    init(buttonType: CustomButtonType) {
        super.init(frame: .zero)
        Utils.addShadow(type: .shadowIsBelow, layer: layer)
        addSubviews()
        
        switch buttonType {
        case .scroll:
            isHidden = true
            buttonImage.image = Images.scrollToTop.getImage()
            button.tintColor = Palette.purple.color
        }
        layout()
        button.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func addSubviews() {
        addSubview(button)
        button.addSubview(buttonImage)
    }
    
    private func layout(){
        
        pin.size(LocalConstants.scrollToTopButtonSize)
        
        button.pin
            .left()
            .right()
            .top()
            .bottom()
        
        buttonImage.pin
            .center()
            .size(LocalConstants.buttonImageSize)
        
        button.layer.cornerRadius = button.frame.height / 2
    }
}

private enum LocalConstants {
    static let scrollToTopButtonSize = CGSize(width: 70, height: 70)
    static let buttonImageSize = CGSize(width: 25, height: 25)
}
