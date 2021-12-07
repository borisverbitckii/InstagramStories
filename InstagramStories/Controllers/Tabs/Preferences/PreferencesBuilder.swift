//
//  PreferencesBuilder.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIViewController

final class PreferencesBuilder {
    
    func build() -> UIViewController {
        let presenter = PreferencesPresenter()
        let view = PreferencesViewController(type: .preferences,presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
}

