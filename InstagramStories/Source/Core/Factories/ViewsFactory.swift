//
//  ViewsFactory.swift
//  InstagramStories
//
//  Created by Борис on 10.12.2021.
//

import UIKit

protocol ViewsFactoryProtocol {
    func getCustomActivityIndicator() -> CustomActivityIndicator
}

final class ViewsFactory: ViewsFactoryProtocol {
    func getCustomActivityIndicator() -> CustomActivityIndicator {
        return CustomActivityIndicator()
    }
}
