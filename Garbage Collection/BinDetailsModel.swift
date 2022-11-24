//
//  BinDetailsModel.swift
//  Garbage Collection
//
//  Created by Sunil Developer on 02/09/22.
//

import Foundation
struct BinModel {
    var binID: String?
    var area: String?
    var locality: String?
    var city : String?
    var garbageType : String?
    var assignDriver : String?
    var cyclePeriod : String?
  
    enum keyValue: String {
        case binID
        case area
        case locality
        case city
        case garbageType
        case assignDriver
        case cyclePeriod
    }
    init(dic: [String:AnyObject]) {
        binID = dic[keyValue.binID.rawValue] as? String
        area = dic[keyValue.area.rawValue] as? String
        locality = dic[keyValue.locality.rawValue] as? String
        city = dic[keyValue.city.rawValue] as? String
        garbageType = dic[keyValue.garbageType.rawValue] as? String
        assignDriver = dic[keyValue.assignDriver.rawValue] as? String
        cyclePeriod = dic[keyValue.cyclePeriod.rawValue] as? String
        
    }
}
 
