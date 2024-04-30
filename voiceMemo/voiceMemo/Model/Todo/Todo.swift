//
//  Todo.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import Foundation

struct Todo : Hashable{ //실제로 foreach에서 이 값을 가지고 돌려줄거기때문에 Hashable을 단다.
    var title : String
    var time : Date
    var day : Date
    var selected : Bool
    
    var convertedDayEndTime: String{
        // 오늘 - 오후 03:00에 알림
        String("\(day.formattedDay) - \(time.formattedTime)에 알림")
    }
}
