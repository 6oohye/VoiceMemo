//
//  TodoViewModel.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import Foundation

//Todo를 만드는 화면, 그 자체 화면 하나.
class TodoViewModel: ObservableObject{
    @Published var title: String
    @Published var time: Date
    @Published var day: Date
    @Published var isDisplayCalenda: Bool
    
    init(title: String = "",
         time: Date = Date(),
         day: Date = Date(),
         isDisplayCalenda: Bool = false
    ) {
        self.title = title
        self.time = time
        self.day = day
        self.isDisplayCalenda = isDisplayCalenda
    }
}

extension TodoViewModel{
    func setIsDisplayCalenda(_ isDisplay: Bool){
        isDisplayCalenda = isDisplay
    }
}
