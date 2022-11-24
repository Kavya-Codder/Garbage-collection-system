//
//  FeedbackDetailsModel.swift
//  Garbage Collection
//
//  Created by Kavya Prajapati on 04/09/22.
//

import Foundation
struct FeedbackModel {
    var title : String?
    var description : String?
    var userName:String?
    var feedbackLevel:String?
    enum keyValue: String {
        case title
        case description
        case feedbackLevel
        case userName
    }
    init(dic: [String:AnyObject]) {
        title = dic[keyValue.title.rawValue] as? String
        description = dic[keyValue.description.rawValue] as? String
        userName = dic[keyValue.userName.rawValue] as? String
        feedbackLevel = dic[keyValue.feedbackLevel.rawValue] as? String
    }
}
 
