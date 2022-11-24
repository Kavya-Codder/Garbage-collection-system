//
//  UserDegault.swift
//  Garbage Collection
//
//  Created by Sunil Kumar on 04/09/2022.
//

import Foundation
enum UserKeys: String {
    case address
    case adharnumber
    case age
    case city
    case dob
    case emai
    case gender
    case id
    case mobile
    case name
    case password
    case userType
    case No = "no"
    case binName
    case binId
    case key
    case isLoggedIn
    case userProfile
}
extension UserDefaults {
class func saveUserVales(user:UserModel?)  {
    UserDefaults.standard.set(user?.address ?? "" ,forKey: UserKeys.address.rawValue)
    UserDefaults.standard.set(user?.adharnumber ?? "", forKey: UserKeys.adharnumber.rawValue)
    UserDefaults.standard.set(user?.age ?? "", forKey:  UserKeys.age.rawValue)
    UserDefaults.standard.set(user?.city ?? "", forKey: UserKeys.city.rawValue)
    UserDefaults.standard.set(user?.dob ?? "", forKey:  UserKeys.dob.rawValue)
    UserDefaults.standard.set(user?.emai ?? "", forKey:  UserKeys.emai.rawValue)
    UserDefaults.standard.set(user?.gender ?? "", forKey:  UserKeys.gender.rawValue)
    UserDefaults.standard.set(user?.id ?? "", forKey:  UserKeys.id.rawValue)
    UserDefaults.standard.set(user?.mobile ?? "", forKey:  UserKeys.mobile.rawValue)
    UserDefaults.standard.set(user?.name ?? "", forKey:  UserKeys.name.rawValue)
    UserDefaults.standard.set(user?.password ?? "", forKey:  UserKeys.password.rawValue)
    UserDefaults.standard.set(user?.userType ?? "", forKey:  UserKeys.userType.rawValue)
    UserDefaults.standard.set(user?.No ?? "", forKey:  UserKeys.No.rawValue)
    UserDefaults.standard.set(user?.binName ?? "", forKey:  UserKeys.binName.rawValue)
    UserDefaults.standard.set(user?.binId ?? "", forKey:  UserKeys.binId.rawValue)
    UserDefaults.standard.set(user?.key ?? "", forKey:  UserKeys.key.rawValue)
    UserDefaults.standard.set(user?.userProfile ?? "", forKey:  UserKeys.userProfile.rawValue)
    }
 
}
