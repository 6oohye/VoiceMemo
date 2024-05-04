//
//  SettingView.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/5/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack{
            //타이틀 뷰
            TitleView()
            
            Spacer()
                .frame(height:  40)
            
            //총 탭 카운트 뷰
            TotalTabCountView()
            Spacer()
                .frame(height: 50)
            //총 탭 무브 뷰
            TotalTabMoveView()
            
            Spacer()
        }
    }
}

//MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack{
            Text("설정")
                .font(.system(size: 30,weight: .bold))
                .foregroundColor(.customBlack)
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 45)
    }
}

//MARK: - 전체 탭 설정된 카운트 뷰
private struct TotalTabCountView: View {
    var body: some View {
        //각각 탭 카운트뷰 (todolist, 메모장 , 음성메모)
        HStack(spacing: 60){
            TabCountView(title: "To do", count: 0)
            TabCountView(title: "메모", count: 1)
            TabCountView(title: "음성메모", count: 6)
        }
    }
}

//MARK: - 각 탭 공통된 카운트 뷰 (공통 뷰 컴포넌트)
private struct TabCountView: View {
    
    private var title : String
    private var count :Int
    
    fileprivate init(
        title: String,
        count: Int
    ) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5){
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.customBlack)
            
            Text("\(count)")
                .font(.system(size: 30,weight: .medium))
                .foregroundColor(.customBlack)
        }
    }
}

//MARK: - 전체 탭 이동 뷰
private struct TotalTabMoveView: View {
    var body: some View {
        VStack{
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.customGray1)
            
            TabMoveView(
                title: "To do 리스트",
                tabAction: {}
            )
            
            TabMoveView(
                title: "메모",
                tabAction: {}
            )
            
            TabMoveView(
                title: "음성메모",
                tabAction: {}
            )
            
            TabMoveView(
                title: "타이머",
                tabAction: {}
            )
            
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.customGray1)
        }
    }
}

//MARK: - 각 탭 이동 뷰
private struct TabMoveView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(
        title: String,
        tabAction: @escaping () -> Void
    ) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button(
            action: tabAction,
            label: {
                HStack{
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundColor(.customBlack)
                    
                    Spacer()
                    
                    Image("arrowRight")
                }
            }
        )
        .padding(.all, 20)
    }
}

#Preview {
    SettingView()
}
