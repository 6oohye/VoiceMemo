//
//  HomeViewModel.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/5/24.
//

import Foundation


class HomeViewModel : ObservableObject{
    @Published var selectedTab: Tab
    @Published var todosCount: Int
    @Published var memosCount: Int
    @Published var voiceRecodersCount: Int
    
    init(
        selectedTab: Tab = .voiceRecoder,
        todosCount: Int = 0,
        memosCount: Int = 0,
        voiceRecodersCount: Int = 0
    ) {
        self.selectedTab = selectedTab
        self.todosCount = todosCount
        self.memosCount = memosCount
        self.voiceRecodersCount = voiceRecodersCount
    }
}
extension HomeViewModel{
    // todosCount~voiceRecoderCount 갯수 변경
    func setTodosCount(_ count : Int){
        todosCount = count
    }
    func setMemosCount(_ count : Int){
        memosCount = count
    }
    func setVoiceRecodersCount(_ count : Int){
        voiceRecodersCount = count
    }
        //탭 변경 메서드
    func changeSelectedTab(_ tab : Tab){
        selectedTab = tab
    }
}
