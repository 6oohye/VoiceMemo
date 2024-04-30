//
//  CustomNavigationBar.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftBtn : Bool
    let isDisplayRightBtn : Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    let rightBtnType: NavigationBtnType
    
    init(isDisplayLeftBtn: Bool = true,
         isDisplayRightBtn: Bool = true,
         leftBtnAction: @escaping () -> Void = {},
         rightBtnAction: @escaping () -> Void = {},
         rightBtnType: NavigationBtnType = .edit
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.rightBtnType = rightBtnType
    }
    
    var body: some View {
        HStack{
            if isDisplayLeftBtn{
                Button ( action: rightBtnAction,label: {
                    Image("leftArrow")
                }
                )
            }
            
            Spacer()
            
            if isDisplayRightBtn{
                Button(
                    action: rightBtnAction,
                    label: {
                        if rightBtnType == .close{
                            Image("close")
                        }else{
                            Text(rightBtnType.rawValue)
                                .foregroundStyle(.customBlack)
                        }
                    }
                )
            }
        }
        .padding(.horizontal,20)
        .frame(height: 20)
    }
}

#Preview {
    CustomNavigationBar()
}
