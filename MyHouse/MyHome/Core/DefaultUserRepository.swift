//
//  UserRepository.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import Foundation
import RealmSwift

final class DefaultUserRepository: UserRepository {
    
    static let sharedInstance = DefaultUserRepository()
    private init() {}
    
    /**
     This function execute the completion closure with user from database if it exists
     else it makes an url request and then return the user. If any error occured the user object
     will be nil and the error will have a value
     - Parameter completion: Coluse to be exucted on response received
    */
    func getUser(completion: ((User?, NetworkError?) -> Void)?) {
        let realm = try! Realm()
        if let user = realm.objects(User.self).first {
            completion?(user, nil)
            return
        } else {
            self.getUserFromServer { (user, error) in
                if let error = error {
                    completion?(nil, error)
                } else if let user = user {
                    completion?(user, nil)
                } else {
                    completion?(nil, NetworkError.defaultError)
                }
            }
        }
    }
    
    /**
     This function updates the user's informations on the database
     - Warning: This function does not not update the user's address
     - Parameters:
        - type: the type of the information that will be updated
        - value: the new value to be setted
     */
    func updateUserInfo(_ type: UserInfo, value: String) {
        let realm = try! Realm()
        if let user = realm.objects(User.self).first {
            try! realm.write {
                switch type {
                case .firstName:
                    user.firstName = value
                case .lastName:
                    user.lastName = value
                case .birthDate:
                    if let date = DateHelper.getDateFromString(value) {
                        let seconds = Int64(date.timeIntervalSince1970)
                        user.birthdate.value = seconds
                    }
                default:
                    break
                }
            }
        }
    }
    
    /**
     This function updates the user's address on the database
     - Parameter newAddress: the new address to be setted
     */
    func updateAddress(_ newAddress: Address) {
        let realm = try! Realm()
        if let user = realm.objects(User.self).first {
            try! realm.write {
                user.address = newAddress
            }
        }
    }
    
    /**
     This function execute the completion closure with user returned and parsed from an url request response.
     If any error occured the user object will be nil and the error will have a value
     - Parameter completion: Coluse to be exucted on request response
    */
    private func getUserFromServer(_ completion: ((User?, NetworkError?) -> Void)?) {
        guard let url = URL(string: Constants.baseURL) else {
            completion?(nil, NetworkError.defaultError)
            return
        }
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            completion?(nil, NetworkError.noInternet)
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            guard let data = data, error == nil else {
                completion?(nil, NetworkError.defaultError)
                return
            }
            do {
                let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let user = self?.parseSaveResponse(responseDictionary)
                completion?(user, nil)
            } catch {
                completion?(nil, NetworkError.defaultError)
            }
        }
        task.resume()
    }
    
    /**
     This function parse a JSON and returns the user
     - Parameter dictionary: the JSON object as a Dictionary
     - Returns: the parsed user object 
     */
    private func parseSaveResponse(_ dictionary: [String: Any]) -> User? {
        if let userDict = dictionary["user"] as? [String: Any] {
            let user = User()
            user.setProperties(fromDictionary: userDict)
            let realm = try! Realm()
            try! realm.write {
                realm.add(user)
            }
            return user
        }
        return nil
    }
}
