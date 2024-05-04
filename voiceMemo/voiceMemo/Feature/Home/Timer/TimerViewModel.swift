//
//  TimerViewModel.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/4/24.
//

import Foundation
import UIKit

class TimerViewModel: ObservableObject{
    @Published var isDisplaySetTimeView : Bool
    @Published var time : Time
    @Published var timer : Timer?
    @Published var timeRemaining : Int
    @Published var isPaused :Bool
    var notificationService : NotificationService
    
    init(
        isDisplaySetTimeView: Bool = true,
        time: Time = .init(hours: 0, minutes: 0, seconds: 0),
        timer: Timer? = nil,
        timeRemaining: Int = 0,
        isPaused: Bool = false,
        notificationService : NotificationService = .init()
        
    ) {
        self.isDisplaySetTimeView = isDisplaySetTimeView
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.notificationService = notificationService
    }
}

//  비즈니스 로직 담기
extension TimerViewModel{
    //뷰에서 상호작용하고있기때문에 private메서드는 아님
    func settingBtnTapped(){
        isDisplaySetTimeView = false //지금 설정하고있는뷰는 꺼줘야함
        timeRemaining = time.convertedSeconds
        startTimer()
        
    }
    
    func cancelBtnTapped(){
        stopTimer()
        isDisplaySetTimeView = true //설정모드로 돌아가야함
    }
    
    func pauseOrRestartBtnTapped(){
        if isPaused {
            startTimer()
        }else{
            timer?.invalidate()
            timer = nil
        }
        isPaused.toggle()
    }
}

//여기서 private를 붙이면 내부에 있는건 안붙여도 프라이빗하게 유지됨
private extension TimerViewModel{
    func startTimer(){
        guard timer == nil else {return}
        
        //백그라운드에서도 알림이 발생시킬 수 있게 하는것.
        var backgroundTaskID : UIBackgroundTaskIdentifier?
        backgroundTaskID = UIApplication.shared.beginBackgroundTask{
            if let task = backgroundTaskID{
                UIApplication.shared.endBackgroundTask(task)
                backgroundTaskID = .invalid
            }
        }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ){_ in
            if self.timeRemaining > 0{
                self.timeRemaining -= 1
            }else {
                self.stopTimer()
                self.notificationService.sendNotification()
                
                if let task = backgroundTaskID{
                    UIApplication.shared.endBackgroundTask(task)
                    backgroundTaskID = .invalid
                }
            }
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
}
