//
//  writeBtn.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/5/24.
//

import SwiftUI

//MARK: - 1️⃣
//어디서든 호출할 수 있게 퍼블릭으로.
public struct writeBtnViewModifier: ViewModifier{
    let action: () -> Void
    
    public init(action: @escaping () -> Void){
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack{
            content
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button (
                        action: action,
                        label: {Image("writeBtn")}
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

//MARK: - 2️⃣
//강사님은 2번 방법을 가장 선호하심.
extension View{
    public func writeBtn(perform action: @escaping () -> Void) -> some View{
        ZStack{
            self
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button (
                        action: action,
                        label: {Image("writeBtn")}
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

//MARK: - 3️⃣
public struct writeBtnView<Content: View> : View {
    let content : Content
    let action : () -> Void
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack{
            content
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button (
                        action: action,
                        label: {Image("writeBtn")}
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}
