//
//  ReachabilityManager.swift
//  InstagramStories
//
//  Created by Борис on 06.12.2021.
//

protocol ReachabilityManagerProtocol: ManagerProtocol {
    func checkIsNetworkIsAvailable(completion: @escaping ()->())
}

final class ReachabilityManager: ReachabilityManagerProtocol {
    
    //MARK: - Public methods
    func checkIsNetworkIsAvailable(completion: @escaping ()->()) {
        let isNetworkIsAvailable = true
        if isNetworkIsAvailable {
            completion()
        } else {
            print(#file, #line, Errors.networkIsNotAvailable)
        }
    }
}
