//
//  HomeView.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var pathModel : PathModel
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack{
            //탭 뷰
            TabView(selection: $homeViewModel.selectedTab){
                TodoListView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .todoList
                            ? "todoIcon_selected"
                            : "todoIcon"
                        )
                    }
                    .tag(Tab.todoList)
                
                MemoListView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .memo
                            ? "memoIcon_selected"
                            : "memoIcon"
                        )
                    }
                    .tag(Tab.memo)
                
                VoiceRecoderView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .voiceRecoder
                            ? "recordIcon_selected"
                            : "recordIcon"
                        )
                    }
                    .tag(Tab.voiceRecoder)
                
                TimerView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .timer
                            ? "timerIcon_selected"
                            : "timerIcon"
                        )
                    }
                    .tag(Tab.timer)
                
                SettingView()
                    .tabItem {
                        Image(
                            homeViewModel.selectedTab == .setting
                            ? "settingIcon_selected"
                            : "settingIcon"
                        )
                    }
                    .tag(Tab.setting)
                
            }
            .environmentObject(homeViewModel)
            
            
            //구분선
            SeperaterLineView()
        }
    }
}

//MARK: - 구분선
private struct SeperaterLineView: View {
   fileprivate var body: some View {
       VStack{
           Spacer()
           
           Rectangle()
               .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
               )
               .frame(height: 10)
               .padding(.bottom, 60)
       }
    }
}

#Preview {
    HomeView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
        .environmentObject(MemoListViewModel())
}
