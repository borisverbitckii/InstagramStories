//
//  ScrollToTopButton.swift
//  InstagramStories
//
//  Created by Борис on 14.12.2021.
//

import UIKit

final class ScrollToTopButton : UIButton {
    
    //MARK: - Private methods
    private let button: UIView = {
        $0.backgroundColor = Palette.white.color
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    //MARK: - Init
    init() {
        super.init(frame: .zero)
        isHidden = true
        Utils.addShadow(type: .shadowIsUnder, layer: layer)
        addSubviews()
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
