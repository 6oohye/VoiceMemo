//
//  Memo.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/1/24.
//

import Foundation
//id값을 이용해볼 것
struct Memo:Hashable{
    var title : String
    var content: String
    var date :Date
    var id = UUID()
    
    var convertedDate: String{
        String("\(date.formattedDay)-\(date.formattedTime)")
    }
}
