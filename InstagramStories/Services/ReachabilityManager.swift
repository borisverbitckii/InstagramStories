//
//  ReachabilityManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

protocol ReachabilityManagerProtocol: ManagerProtocol {
    var isNetworkAvailable: Bool { get }
}

final class ReachabilityManager: ReachabilityManagerProtocol {
    
    //MARK: - Public properties
    private(set) var isNetworkAvailable = true
}
