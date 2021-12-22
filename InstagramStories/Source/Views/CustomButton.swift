//
//  ScrollToTopButton.swift
//  InstagramStories
//
//  Created by Борис on 14.12.2021.
//

import UIKit

enum CustomButtonType {
    case close
    case share
    case save
    case scroll
}

final class CustomButton : UIButton {
    
    //MARK: - Private methods
    private let button: UIImageView = {
        $0.backgroundColor = Palette.white.color
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    //MARK: - Init
    init(buttonType: CustomButtonType) {
        super.init(frame: .zero)
        Utils.addShadow(type: .shadowIsBelow, layer: layer)
        addSubviews()
        
        switch buttonType {
        case .close:
            break
        case .share:
            break
        case .save:
            break
        case .scroll:
            isHidden = true
            break
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
    }
    
    private func layout(){
        
        pin.size(LocalConstants.scrollToTopButtonSize)
        
        button.pin
            .left()
            .right()
            .top()
            .bottom()
        
        button.layer.cornerRadius = button.frame.height / 2
    }
}

private enum LocalConstants {
    static let scrollToTopButtonSize = CGSize(width: 70, height: 70)
}
