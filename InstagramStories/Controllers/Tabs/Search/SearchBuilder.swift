//
//  SearchBuilder.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

import UIKit.UIViewController

final class SearchBuilder {
    
    //MARK: - Private methods
    private let dataServiceFacade: DataServicesFacadeProtocol
    
    //MARK: - Init
    init(dataServiceFacade: DataServicesFacadeProtocol) {
        self.dataServiceFacade = dataServiceFacade
    }
    
    //MARK: - Public methods
    func build() -> UIViewController {
        let presenter = SearchPresenter(dataServicesFacade: dataServiceFacade)
        let view = SearchViewController(type: .search,presenter: presenter)
        presenter.injectView(view: view)
        
        return view
    }
}
