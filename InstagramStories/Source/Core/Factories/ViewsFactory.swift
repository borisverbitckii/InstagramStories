//
//  ViewsFactory.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import UIKit

protocol ViewsFactoryProtocol {
    func getCustomActivityIndicator() -> CustomActivityIndicator
    func getScrollToTopButton() -> ScrollToTopButton
    func getTabBar() -> CustomTabBarProtocol
}

final class ViewsFactory: ViewsFactoryProtocol {
    func getCustomActivityIndicator() -> CustomActivityIndicator {
        return CustomActivityIndicator()
    }

    func getScrollToTopButton() -> ScrollToTopButton {
        return ScrollToTopButton()
    }

    func getTabBar() -> CustomTabBarProtocol {
        return CustomTabBar()
    }
}
