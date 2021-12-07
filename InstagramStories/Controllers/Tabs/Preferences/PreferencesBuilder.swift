//
//  PreferencesBuilder.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIViewController

final class PreferencesBuilder {
    
    //MARK: - Private methods
    private let dataServiceFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServiceFacade: DataServicesFacadeProtocol) {
        self.dataServiceFacade = dataServiceFacade
    }
    
    func build() -> UIViewController {
        let presenter = PreferencesPresenter(dataServicesFacade: dataServiceFacade)
        let view = PreferencesViewController(presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
}

