//
//  AppAssembler.swift
//  InstagramStories
//
//  Created by Борис on 07.12.2021.
//

import Swinject

final class AppAssembler {
    static let assembler = Assembler([TabBarModuleAssembly(),
                                      DataServicesFacadeModuleAssembly(),
                                      RootCoordinatorAssembly(),
                                      SearchModuleAssembly(),
                                      FavoritesModuleAssembly(),
                                      PreferencesModuleAssembly()])
}
