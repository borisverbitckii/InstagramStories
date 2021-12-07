//
//  PresentationBuilder.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import UIKit.UIViewController

final class PresentationBuilder {
    
    //MARK: - Private methods
    private let dataServiceFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServiceFacade: DataServicesFacadeProtocol) {
        self.dataServiceFacade = dataServiceFacade
    }
    
    //MARK: - Public methods
    func build() -> UIViewController {
        let presenter = PresentationPresenter()
        let view = PresentationViewController(presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
}
