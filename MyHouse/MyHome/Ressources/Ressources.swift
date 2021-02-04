//
//  Ressources.swift
//  MyHome
//
//  Created by Salmen NOUIR on 31/01/2021.
//

import UIKit

struct Ressources {
    
    struct Colors {
        static let yellow = UIColor(rgb: 0xF4D03F)
        static let white = UIColor(named: "White")
        static let black = UIColor(named: "Black")
        static let shadow = UIColor(named: "ShadowColor")
        static let mainDarkColor = UIColor(named: "MainDarkColor")
    }
    
    struct Fonts {
        static func latoRegular(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Lato-Regular", size: size) ?? .systemFont(ofSize: size)
        }
        
        static func latoBold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Lato-Bold", size: size) ?? .boldSystemFont(ofSize: size)
        }
        
        static func dosisExtraBold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Dosis-ExtraBold", size: size) ?? .systemFont(ofSize: size, weight: .black)
        }
    }
    
    struct Images {
        static let homeIc = UIImage(named: "home")
        static let profileIc = UIImage(named: "user")
        static let filterIc = UIImage(named: "filter")
        static let editIc = UIImage(named: "edit")
        static let heaterIc = UIImage(named: "heater")
        static let lightIc = UIImage(named: "light")
        static let rollerShutterIc = UIImage(named: "roller-shutter")
        static let leftArrow = UIImage(named: "left-arrow")
        static let lightOff = UIImage(named: "lightbulb-off")
        static let lightOn = UIImage(named: "lightbulb-on")
        static let coldIc = UIImage(named: "cold")
        static let hotIc = UIImage(named: "hot")
    }
    
    struct Strings {
        static let homeTitle = NSLocalizedString("HomeTitle", comment: "")
        static let profileTitle = NSLocalizedString("ProfileTitle", comment: "")
        static let lightValue = NSLocalizedString("LightValue", comment: "")
        static let heaterValue = NSLocalizedString("HeaterValue", comment: "")
        static let rollerValue = NSLocalizedString("RollerValue", comment: "")
        static let lightName = NSLocalizedString("LightName", comment: "")
        static let heaterName = NSLocalizedString("HeaterName", comment: "")
        static let rollerName = NSLocalizedString("RollerName", comment: "")
        static let homeMainTitle = NSLocalizedString("HomeMainTitle", comment: "")
        static let alertDoneButton = NSLocalizedString("AlertDoneButton", comment: "")
        static let errorTitle = NSLocalizedString("ErrorTitle", comment: "")
        static let filtersTitle = NSLocalizedString("FiltersTitle", comment: "")
        static let doneButtonTitle = NSLocalizedString("DoneButtonTitle", comment: "")
        static let cancelButtonTitle = NSLocalizedString("CancelButtonTitle", comment: "")
        static let firstNameTitle = NSLocalizedString("FirstNameTitle", comment: "")
        static let lastNameTitle = NSLocalizedString("LastNameTitle", comment: "")
        static let birthDateTitle = NSLocalizedString("BirthDateTitle", comment: "")
        static let addressTitle = NSLocalizedString("AddressTitle", comment: "")
        static let streetCodeTitle = NSLocalizedString("StreetCodeTitle", comment: "")
        static let streetTitle = NSLocalizedString("StreetTitle", comment: "")
        static let cityTitle = NSLocalizedString("CityTitle", comment: "")
        static let postalCodeTitle = NSLocalizedString("PostalCodeTitle", comment: "")
        static let countryTitle = NSLocalizedString("CountryTitle", comment: "")
        static let profileMainTitle = NSLocalizedString("ProfileMainTitle", comment: "")
        static let editFNameTitle = NSLocalizedString("EditFirstNameTitle", comment: "")
        static let editLNameTitle = NSLocalizedString("EditLastNameTitle", comment: "")
        static let editBirthdateTitle = NSLocalizedString("EditBirthDateTitle", comment: "")
        static let editAddressTitle = NSLocalizedString("EditAddressTitle", comment: "")
        static let editInfoSaveBtnTitle = NSLocalizedString("EditInfoSaveBtnTitle", comment: "")
    }
}
