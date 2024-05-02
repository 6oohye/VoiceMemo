//
//  Double+Extensions.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/2/24.
//

import Foundation
//Double 타입에서 몇시 몇분 표현
    //03:05  이런식으로 표현
extension Double{
    var formattedTimeInterval: String{
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds/60) % 60
        
        return String(format: "%02d:%02d",minutes,seconds)
    }
}

