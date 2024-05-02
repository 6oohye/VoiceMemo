//
//  VoiceRecoderViewModel.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/2/24.
//

import AVFoundation

class VoiceRecoderViewModel:NSObject, ObservableObject, AVAudioPlayerDelegate{
    // ObservableObject: 오디오레코드매니저라는 서비스 객체를 뷰에 얹히기 위해 채택
    // AVAudioPlayerDelegate: 음성메모에 재생, 끝지점 등 내장되어있는 delegate메서드를 사용하기 위하여 채택
    // NSObject: VAudioPlayerDelegate가 내부적으로 NSObject프로토콜을 채택하고있음. 이 프로토콜은 코어 파운데이션 속성을 가진 타입이기에 이 객체들이 실행되는 런타임시에 런타임매커니즘이 해당 프로토콜을 기반으로 동작하게됨.
    @Published var isDisplayRemoveVoiceRecoderAlert : Bool
    @Published var isDisplayErrorAlert : Bool
    @Published var errorAlertMessage : String
    
    //음성메모 녹음 관련 프로퍼티
    var audioRecoder: AVAudioRecorder?
    @Published var isRecording : Bool
    
    //음성메모 재생 관련 프로퍼티
    var audioPlayer :AVAudioPlayer?
    @Published var isPlaying : Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTimer : Timer?
    
    //음성메모된 파일
    var recordedFiles : [URL]
    
    //현재 선택된 음성메모 파일
    @Published var selectedRecordedFile : URL?
    
    init(
        isDisplayRemoveVoiceRecoderAlert: Bool = false,
        isDisplayErrorAlert: Bool = false,
        errorAlertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecordedFile: URL? = nil
    ) {
        self.isDisplayRemoveVoiceRecoderAlert = isDisplayRemoveVoiceRecoderAlert
        self.isDisplayErrorAlert = isDisplayErrorAlert
        self.errorAlertMessage = errorAlertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecordedFile = selectedRecordedFile
    }
}

//MARK: - 뷰에서 일어날 수 있는 로직
extension VoiceRecoderViewModel{
    func voiceRecordCellTapped(_ recordedFile: URL){
        if selectedRecordedFile != recordedFile{
            //재생정지 메소드 호출
            stopPlying()
            selectedRecordedFile = recordedFile
        }
    }
    
    func removeBtnTapped(){
        //삭제 얼럿 노출을 위한 상태 변경 메서드 호출
        setIsDisplayRemoveVoiceRecoderAlert(true)
    }
    
    func removeSelectedVoiceRecord(){
        //guard문과 throw 키워드를 사용해서 오류를 던져주었다. guard문에서 오류가 발생하면 else로 넘어가서 폰에러를 발생시키고 함수를 종료시킨다. 이 메서드를 사용하려면 오류를 할수도 있기 때문에 do-catch나 try-catch를 사용해서 오류를 처리할 수 있어야한다.
        guard let fileToRemove = selectedRecordedFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else{
            //선택된 음성메모를 찾을 수 없다는 에러 얼럿 노출
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do{
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecordedFile = nil
            //재생 정지 메서드 호출
            stopPlying()
            //삭제 성공 얼럿 노출
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        }catch{
            //삭제 실패 오류 얼럿 노출
            displayAlert(message: "선택된 음성메모 삭제 중 오류가 발생했습니다")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecoderAlert(_ isDisplay :Bool){
        isDisplayRemoveVoiceRecoderAlert = isDisplay
    }
    
    private func setErrorAlretMessage(_ message : String){
        errorAlertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool){
        isDisplayErrorAlert = isDisplay
    }
    
    private func displayAlert(message :String){
        setErrorAlretMessage(message)
        setIsDisplayErrorAlert(true)
    }
    
}

//MARK: - 음성메모 녹음 관련
extension VoiceRecoderViewModel {
    func recordBtnTapped(){
        selectedRecordedFile = nil //다시 재생을 해줄거니깐 선택된건 nil로 바꿔줘야함
        
        if isPlaying{
            //재생 정지 메서드
            stopPlying()
            //녹음 시작 메서드
            stopRecording()
        }else if isRecording{
            //녹음 정지 메서드
            stopRecording()
        }else{
            //녹음 시작 메서드
            startRecording()
        }
    }
    
    private func startRecording(){ //버튼이 탭 됐을때만 실행되지 뷰에서 직접적으로 호출하지않기때문에 private으로 호출
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음\(recordedFiles.count + 1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey : 1 ,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do{ //우리는 녹음을 시킬 수 있어야함
            audioRecoder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecoder?.record()
            self.isRecording = true
        }catch{
            displayAlert(message: "녹음 중 오류가 발생했습니다.")
        }
    }
    
    private func stopRecording(){
        audioRecoder?.stop()
        self.recordedFiles.append(self.audioRecoder!.url) //url을 가져와서 recordedFiles에 저장
        self.isRecording = false
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//MARK: - 음성메모 재생 관련
extension VoiceRecoderViewModel{
    func startPlaying(recordingURL: URL) {
       do {
         audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
         audioPlayer?.delegate = self
         audioPlayer?.play()
         self.isPlaying = true
         self.isPaused = false
         self.progressTimer = Timer.scheduledTimer(
           withTimeInterval: 0.1,
           repeats: true
         ) { _ in
           self.updateCurrentTime()
         }
       } catch {
         displayAlert(message: "음성메모 재생 중 오류가 발생했습니다.")
       }
     }
    
    private func updateCurrentTime(){
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopPlying(){
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate() //프로그래스타임 초기화
        self.isPlaying = false
        self.isPaused = false
    }
    
    func pausePlaying(){
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    func resumePlaying(){
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    func getFileInfo (for url: URL) -> (Date?, TimeInterval?){
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?
        
        do{
            let fileAttribute = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttribute[.creationDate] as? Date
        }catch{
            displayAlert(message: "선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }
        
        do{
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        }catch{
            displayAlert(message: "선택된 음성메모 파일의 재생시간을 불러올 수 없습니다.")
        }
        
        return(creationDate, duration)
    }
}

