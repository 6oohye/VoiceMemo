//
//  OnboardingContent.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/29/24.
//

import Foundation
struct OnboardingContent : Hashable{ //추후에 탭뷰에서도 사용하기때문에 해쉬어블로 프로토콜을 채택함.
    var imageFileName: String
    var title: String
    var subTitle: String
    
    init(imageFileName: String, title: String, subTitle: String) {
        self.imageFileName = imageFileName
        self.title = title
        self.subTitle = subTitle
    }
}
