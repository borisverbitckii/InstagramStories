//
//  CustomTabBarController.swift
//  InstagramStories
//
//  Created by Борис on 15.12.2021.
//

import UIKit.UIViewController

protocol CustomTabBarProtocol {
    
}

final class CustomTabBar: UITabBar, UITabBarDelegate, CustomTabBarProtocol {
    
    //MARK: - Private properties
    private let tabBarView: UIView = {
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBar()
        addSubview(tabBarView)
        tabBarView.backgroundColor = Palette.white.color
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupTabBar() {
        Utils.addShadow(type: .shadowIsUnder, layer: layer)
        backgroundColor = .clear
        shadowImage = UIImage()
        backgroundImage = UIImage()
    }
    
    private func layout() {
        pin
            .width(UIScreen.main.bounds.width)
            .bottom(layoutMargins)
            .height(LocalConstants.tabBarHeight)
        
        tabBarView.frame = frame
        tabBarView.roundCorners(corners: [.topLeft, .topRight], radius: frame.height / 2)
    }
}

private enum LocalConstants {
    static let tabBarHeight: CGFloat = 83
}
