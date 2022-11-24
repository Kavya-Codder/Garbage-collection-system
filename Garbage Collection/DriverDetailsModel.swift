//
//  DriverDetailsModel.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 03/09/22.
//

import Foundation
struct DriverModel {
    var name : String?
    var dob : String?
    var age: String?
    var mobile : String?
    var gender : String?
    var address: String?
    var city : String?
    var email : String?
    var password : String?
    var adharnumber: String?
    var no: String?
    var assignBin: String?
    var id : String?
    var userType : String?
    
    enum keyValue: String {
        case name
        case dob
        case age
        case mobile
        case gender
        case address
        case city
        case email
        case password
        case adharnumber
        case no
        case assignBin
        case id
        case userType
    }
    init(dic: [String:AnyObject]) {
        name = dic[keyValue.name.rawValue] as? String
        dob = dic[keyValue.dob.rawValue] as? String
        age = dic[keyValue.age.rawValue] as? String
        mobile = dic[keyValue.mobile.rawValue] as? String
        gender = dic[keyValue.gender.rawValue] as? String
        address = dic[keyValue.address.rawValue] as? String
        city = dic[keyValue.city.rawValue] as? String
        email = dic[keyValue.email.rawValue] as? String
        password = dic[keyValue.password.rawValue] as? String
        adharnumber = dic[keyValue.adharnumber.rawValue] as? String
        no = dic[keyValue.no.rawValue] as? String
        assignBin = dic[keyValue.assignBin.rawValue] as? String
        id = dic[keyValue.id.rawValue] as? String
        userType = dic[keyValue.userType.rawValue] as? String
    }
}
 
