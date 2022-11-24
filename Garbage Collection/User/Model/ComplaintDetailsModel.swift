//
//  ComplaintDetailsModel.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 03/09/22.
//

import Foundation
struct ComplaintModel {
    var name : String?
    var binID : String?
    var area : String?
    var locality: String?
    var city : String?
    var assignBin : String?
    var status : String?
    var complaint : String?
    var userName: String?
    var complainStatus: String?
    var key:String = ""
    enum keyValue: String {
        case name
        case binID
        case area
        case locality
        case city
        case assignBin
        case status
        case userName
        case complaint
        case complainStatus
    }
    init(dic: [String:AnyObject], key: String) {
        name = dic[keyValue.name.rawValue] as? String
        binID = dic[keyValue.binID.rawValue] as? String
        area = dic[keyValue.area.rawValue] as? String
        locality = dic[keyValue.locality.rawValue] as? String
        city = dic[keyValue.city.rawValue] as? String
        assignBin = dic[keyValue.assignBin.rawValue] as? String
        status = dic[keyValue.status.rawValue] as? String
        complaint = dic[keyValue.complaint.rawValue] as? String
        userName = dic[keyValue.userName.rawValue] as? String
        complainStatus = dic[keyValue.complainStatus.rawValue] as? String
        self.key = key
    }
}
 
