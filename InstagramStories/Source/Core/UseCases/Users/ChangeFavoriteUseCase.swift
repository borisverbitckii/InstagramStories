//
//  SaveFavoriteUseCase.swift
//  InstagramStories
//
//  Created by Борис on 27.12.2021.
//

import RealmSwift
import UIKit.UIImage

protocol ChangeFavoritesUseCaseProtocol {
    func saveFavoritesUser(user: RealmInstagramUserProtocol,isSavedCompletion: @escaping (Bool)->())
    func changeFavoriteUser(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool)->())
    func loadFavoritesUsers(completion: @escaping ([RealmInstagramUserProtocol]) -> ())
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ())
    func removeFavoriteUser(user: RealmInstagramUserProtocol, isRemovedCompletion: @escaping (Bool)->())
}

final class ChangeFavoritesUseCase: UseCase {
    //MARK: - Private properties
    private let usersRepository: UsersRepositoryProtocol
    private let fetchImageRepository: UserImageRepositoryProtocol
    
    //MARK: - Init
    init(usersRepository: UsersRepositoryProtocol,
         fetchImageRepository: UserImageRepositoryProtocol) {
        self.usersRepository = usersRepository
        self.fetchImageRepository = fetchImageRepository
    }
}

//MARK: - extension + SaveRecentUseCaseProtocol
extension ChangeFavoritesUseCase: ChangeFavoritesUseCaseProtocol {
    func removeFavoriteUser(user: RealmInstagramUserProtocol, isRemovedCompletion: @escaping (Bool) -> ()) {
        usersRepository.removeUserFromBD(user: user, isDeletedCompletion: isRemovedCompletion)
    }
    
    func loadFavoritesUsers(completion: @escaping ([RealmInstagramUserProtocol]) -> ()) {
        usersRepository.fetchUsersFromBD(userType: .favorite, completion: completion)
    }
    
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        fetchImageRepository.fetchImageData(urlString: stringURL) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func changeFavoriteUser(user: RealmInstagramUserProtocol, isChangedCompletion: @escaping (Bool)->()) {
        usersRepository.changeUserInBD(user: user, isChangedCompletion: isChangedCompletion)
    }
    
    func saveFavoritesUser(user: RealmInstagramUserProtocol,isSavedCompletion: @escaping (Bool)->()) {
        usersRepository.saveUserToBD(user: user, isSavedCompletion: isSavedCompletion)
    }
}
