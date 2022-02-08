//
//  FireBaseManager.swift
//  InstaStories
//
//  Created by Борис on 07.02.2022.
//

import Firebase

protocol FireBaseManagerProtocol {
    func fetchCredentials(completion: @escaping ([String:String]) -> ())
    func removeCredentials(pathString: String)
}

final class FireBaseManager {
    
    //MARK: - Private properties
    let dataBase = Database.database().reference()
    
}

//MARK: - extension + FireBaseManagerProtocol
extension FireBaseManager: FireBaseManagerProtocol {
    func fetchCredentials(completion: @escaping ([String:String]) -> ()) {
        
        Utils.addCredentialsToFireBase() /// helper to send new credentials to firebase
        
        dataBase.observeSingleEvent(of: .value) { snapshot, _ in
            guard let value = snapshot.value as? [String: String] else { return }
            
            var finalDict = [String: String]()
            
            for pair in value {
                let key = Utils.replaceCharacter(value: pair.key, of: "?", with: ".")
                finalDict[key] = pair.value
            }
            completion(finalDict)
        }
    }
    
    func removeCredentials(pathString: String) {
        let path = Utils.replaceCharacter(value: pathString, of: ".", with: "?")
        dataBase.child(path).removeValue()
    }
}
