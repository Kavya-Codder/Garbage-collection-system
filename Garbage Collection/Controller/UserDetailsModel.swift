//
//  UserDetailsModel.swift
//  Garbage Collection
//
//  Created by Sunil Kumar on 01/09/2022.
//

import Foundation
struct UserModel {
    var address: String?
    var adharnumber: String?
    var age: String?
    var city : String?
    var dob : String?
    var emai : String?
    var gender : String?
    var id : String?
    var mobile : String?
    var name : String?
    var password : String?
    var userType : String?
    var No: String?
    var binName: String?
    var binId: String?
    var key:String = ""
    var OTP: String?
    var userProfile: String?
    enum keyValue: String {
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
        case OTP
        case userProfile
    }
    init(dic: [String:AnyObject],key: String) {
        address = dic[keyValue.address.rawValue] as? String
        adharnumber = dic[keyValue.adharnumber.rawValue] as? String
        age = dic[keyValue.age.rawValue] as? String
        city = dic[keyValue.city.rawValue] as? String
        dob = dic[keyValue.dob.rawValue] as? String
        emai = dic[keyValue.emai.rawValue] as? String
        gender = dic[keyValue.gender.rawValue] as? String
        id = dic[keyValue.id.rawValue] as? String
        mobile = dic[keyValue.mobile.rawValue] as? String
        name = dic[keyValue.name.rawValue] as? String
        password = dic[keyValue.password.rawValue] as? String
        userType = dic[keyValue.userType.rawValue] as? String
        binName = dic[keyValue.binName.rawValue] as? String
        binId = dic[keyValue.binId.rawValue] as? String
        No = dic[keyValue.No.rawValue] as? String
        OTP = dic[keyValue.OTP.rawValue] as? String
        self.key = key
        userProfile = dic[keyValue.userProfile.rawValue] as? String
    }
}
 
