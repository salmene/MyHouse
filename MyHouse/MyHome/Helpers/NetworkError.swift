//
//  NetworkError.swift
//  MyHome
//
//  Created by Salmen NOUIR on 01/02/2021.
//

import Foundation

enum NetworkError: String {
    case noInternet = "NoInternetError"
    case defaultError = "DefaultError"
    case notFound = "NotFound"
    
    func getDescription() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
