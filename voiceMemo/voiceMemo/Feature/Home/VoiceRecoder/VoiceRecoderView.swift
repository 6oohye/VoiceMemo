//
//  VoiceRecoderView.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/2/24.
//

import SwiftUI

struct VoiceRecoderView: View {
    @StateObject private var voiceRecoderViewModel = VoiceRecoderViewModel()
    var body: some View {
        ZStack{
            //타이틀뷰
            
            //안내뷰
            //보이스 레코더 리스트 뷰
            
            //녹음버튼 뷰
        }
    }
}

//MARK: - 타이틀 뷰
private struct TitleView : View {
    fileprivate var body: some View {
        HStack{
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.customBlack)
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

//MARK: - 음성메모 안내뷰
private struct AnnouncementView:View {
    fileprivate var body: some View {
        VStack(spacing: 15){
            Rectangle()
                .fill(Color.customCoolGray)
                .frame(height: 1)
            Spacer()
                .frame(height: 180)
            
            Image("pencil")
                .renderingMode(.template)
            Text("현재 등록된 음성메모가 없습니다.")
            Text("하단의 녹음버튼을 눌러 음성메모를 시작해주세요.")
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

//MARK: - 음성메모 리스트 뷰
private struct VoiceRecoderListView: View {
    @ObservedObject private var voiceRecoderViewModel: VoiceRecoderViewModel
    
    fileprivate init(voiceRecoderViewModel: VoiceRecoderViewModel) {
        self.voiceRecoderViewModel = voiceRecoderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical){
            VStack{
                Rectangle()
                    .fill(Color.customCoolGray)
                    .frame(height: 1)
                
                ForEach(voiceRecoderViewModel.recordedFiles, id: \.self){recordedFile in
                    //음성메모 셀 뷰 호출
                }
            }
        }
    }
}

//MARK: - 음성메모 셀 뷰 구현
private struct VoiceRecoderCellView: View {
    @ObservedObject private var voiceRecoderViewModel: VoiceRecoderViewModel
    
    private var recordrdFile : URL
    private var creationDate : Date?
    private var duration : TimeInterval?
    private var progressBarValue: Float{
        if voiceRecoderViewModel.selectedRecordedFile == 
    }
    
    fileprivate var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}


#Preview {
    VoiceRecoderView()
}
