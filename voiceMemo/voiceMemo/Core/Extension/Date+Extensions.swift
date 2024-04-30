//
//  Date+Extensions.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import Foundation

extension Date{
    var formattedTime: String{
        let formatter = DateFormatter() //포매터로 데이터포메터라는 인스턴스를 가지게됨.
        formatter.locale = Locale(identifier: "ko_KR") 
        //포메터에 로케일은 한국 지정으로!
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self)
    }
    
    //오늘인지 아니면 다른날짜인지 판단할 수 있는 프로퍼티
    var formattedDay: String{
        let now = Date()
        let calender = Calendar.current
        
        let nowStartOfDay = calender.startOfDay(for: now)
        let dateStartOfDay = calender.startOfDay(for: self)
        let numOfDaysDifference = calender.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day!
                                                                                                    //강제 형 변화! day로 추출
        if numOfDaysDifference == 0 {
            return "오늘"
        }else{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
    }
}
