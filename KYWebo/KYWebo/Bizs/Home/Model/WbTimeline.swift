//
//  WbTimeline.swift
//  KYWebo
//
//  Created by KYCoder on 2017/8/11.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class WbTimeline: NSObject {
    
    var interval: Int = 0
    var uveBlank: Int = 0
    var hasUnread: Int = 0
    var totalNumber: Int = 0
    
    var maxID: String = ""
    var sinceID: String = ""
    
    var statuses: Array<WbStatus> = []

    public static func modelCustomPropertyMapper() -> [String : Any]? {
        return [
            "uveBlank"       : "uve_blank",
            "hasUnread"      : "has_unread",
            "totalNumber"    : "total_number",
            "maxID"          : "max_id",
            "sinceID"        : "since_id"
        ]
    }
    
    public static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["statuses": WbStatus.classForCoder()]
    }
}

