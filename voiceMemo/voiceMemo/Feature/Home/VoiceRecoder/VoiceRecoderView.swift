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
            VStack{
                TitleView()
                
                if voiceRecoderViewModel.recordedFiles.isEmpty{
                    AnnouncementView()
                }else{
                    VoiceRecoderListView(
                        voiceRecoderViewModel: voiceRecoderViewModel)
                    .padding(.top, 15)
                }
                Spacer()
            }
            RecordBtnView(voiceRecoderViewModel: voiceRecoderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "선택된 메모를 삭제하시겠습니까?",
            isPresented: $voiceRecoderViewModel.isDisplayRemoveVoiceRecoderAlert
        ){
            Button("삭제",role: .destructive){
                voiceRecoderViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role: .cancel){}
        }
        
        .alert(
            voiceRecoderViewModel.alertMessage,
            isPresented: $voiceRecoderViewModel.isDisplayAlert
        ){
            Button("확인", role: .cancel){}
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
                    VoiceRecoderCellView(
                        voiceRecoderViewModel: voiceRecoderViewModel,
                        recordrdFile: recordedFile)
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
        if voiceRecoderViewModel.selectedRecordedFile == recordrdFile && (voiceRecoderViewModel.isPlaying || voiceRecoderViewModel.isPaused){
            return Float(voiceRecoderViewModel.playedTime) / Float(duration ?? 1)
        }else{
            return 0
        }
    }
    
    fileprivate init(
        voiceRecoderViewModel: VoiceRecoderViewModel,
        recordrdFile: URL
    ) {
        self.voiceRecoderViewModel = voiceRecoderViewModel
        self.recordrdFile = recordrdFile
        (self.creationDate, self.duration) = voiceRecoderViewModel.getFileInfo(for: recordrdFile)
    }
    
    fileprivate var body: some View {
        VStack{
            Button(
                action: {
                    voiceRecoderViewModel.voiceRecordCellTapped(recordrdFile)
                }, label: {
                    VStack{
                        HStack{
                            Text(recordrdFile.lastPathComponent)
                                .font(.system(size: 16))
                                .foregroundColor(.customBlack)
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 5)
                        
                        HStack{
                            if let creationDate = creationDate{
                                Text(creationDate.formattedVoiceRecoderTime)
                                    .font(.system(size: 14))
                                    .foregroundColor(.customIconGray)
                            }
                            
                            Spacer()
                            
                            if voiceRecoderViewModel.selectedRecordedFile != recordrdFile,
                               let duration = duration{
                                Text(duration.formattedTimeInterval)
                                    .font(.system(size: 14))
                                    .foregroundColor(.customIconGray)
                            }
                        }
                    }
                }
            )
            .padding(.horizontal, 20)
            
            if voiceRecoderViewModel.selectedRecordedFile == recordrdFile{
                VStack{
                    //프로그래스바
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack{
                        Text(voiceRecoderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.customIconGray)
                        
                        Spacer()
                        
                        if let duration = duration{
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10,weight: .medium))
                                .foregroundColor(.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack{
                        Spacer()
                        
                        Button( //플레이버튼
                            action: {
                                if voiceRecoderViewModel.isPaused{
                                    voiceRecoderViewModel.resumePlaying()
                                }else{
                                    voiceRecoderViewModel.startPlaying(recordingURL: recordrdFile)
                                }
                            }, label: {
                                Image("play")
                                    .renderingMode(.template)
                                    .foregroundColor(.customBlack)
                            }
                        )
                        
                        Spacer()
                            .frame(width: 10)
                        Button( //정지버튼
                            action: {
                                if voiceRecoderViewModel.isPlaying{
                                    voiceRecoderViewModel.pausePlaying()
                                }
                            }, label: {
                                Image("pause")
                                    .renderingMode(.template)
                                    .foregroundColor(.customBlack)
                            }
                        )
                        Spacer()
                        
                        Button(
                            action: {
                                voiceRecoderViewModel.removeBtnTapped()
                            }, label: {
                                Image("trash")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.customBlack)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
        }
    }
}

//MARK: - 프로그래스 바
private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader{geometry in
            ZStack(alignment: .leading){
                Rectangle()
                    .fill(Color.customGray2)
                
                Rectangle()
                    .fill(Color.customGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

//MARK: - 녹음 버튼 뷰
private struct RecordBtnView: View {
    @ObservedObject private var voiceRecoderViewModel: VoiceRecoderViewModel
    
    fileprivate init(voiceRecoderViewModel: VoiceRecoderViewModel) {
        self.voiceRecoderViewModel = voiceRecoderViewModel
    }
    
    fileprivate var body: some View {
        VStack{
            Spacer()
            
            HStack{
                Spacer()
                
                Button(
                    action: {
                        voiceRecoderViewModel.recordBtnTapped()
                    }, label: {
                        if voiceRecoderViewModel.isRecording{
                            Image("mic_recording")
                        }else{
                            Image("mic")
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    VoiceRecoderView()
}
