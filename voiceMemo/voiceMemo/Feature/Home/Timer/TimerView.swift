//
//  TimerView.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/4/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject  var timerViewModel = TimerViewModel()
    
    
    var body: some View {
        if timerViewModel.isDisplaySetTimeView{
            //타이머 설정뷰
            SetTimerView(timerViewModel: timerViewModel)
            
        }else{
            //타이머 작동뷰
            TimerOperationView(timerViewModel: timerViewModel)
        }
        
    }
}

//MARK: -타이머 설정 뷰
private struct SetTimerView: View {
    @ObservedObject private var timerViewModel : TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack{
            //타이틀
            TitleView()
            Spacer()
                .frame(height: 50)
            //타이머 피커뷰
            TimePickerView(timerViewModel: timerViewModel)
            Spacer()
                .frame(height: 30)
            //설정하기버튼뷰
            TimerCreateBtnView(timerViewModel: timerViewModel)
            
            Spacer()
        }
    }
}

//MARK: -타이틀 뷰
private struct TitleView: View {
    fileprivate  var body: some View {
        HStack{
            Text("타이머")
                .font(.system(size: 30,weight: .bold))
                .foregroundColor(Color.customBlack)
            Spacer()
        }
        .padding(.horizontal,30)
        .padding(.top,30)
    }
}

//MARK: - 타이머 피커 뷰
private struct TimePickerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    fileprivate var body: some View {
        VStack{
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
            
            HStack{
                Picker("Hours", selection: $timerViewModel.time.hours){
                    ForEach(0..<24){ hour in
                        Text("\(hour)시")
                    }
                }
                Picker("Minutes", selection: $timerViewModel.time.minutes){
                    ForEach(0..<60){ minute in
                        Text("\(minute)분")
                    }
                }
                Picker("Seconds", selection: $timerViewModel.time.seconds){
                    ForEach(0..<60){ second in
                        Text("\(second)초")
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
        }
    }
}

//MARK: - 타이머 생성 버튼 뷰
private struct TimerCreateBtnView: View {
    @ObservedObject private var timerViewModel : TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    fileprivate var body: some View {
        HStack{
            Button {
                timerViewModel.settingBtnTapped()
            } label: {
                Text("설정하기")
                    .foregroundColor(Color.customGreen)
                    .font(.system(size: 18, weight: .bold))
            }
        }
    }
}

//MARK: - 타이머 작동 뷰
private struct TimerOperationView: View {
    @ObservedObject private var timerViewModel : TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        //ZStack으로 원모양과 타이머 글씨를 겹쳐서 표현
        VStack {
          ZStack {
            VStack {
              Text("\(timerViewModel.timeRemaining.formattedTimeString)")
                .font(.system(size: 28))
                .foregroundColor(.customBlack)
                .monospaced()
              
              HStack(alignment: .bottom) {
                Image(systemName: "bell.fill")
                
                Text("\(timerViewModel.time.convertedSeconds.formattedSettingTime)")
                  .font(.system(size: 16))
                  .foregroundColor(.customBlack)
                  .padding(.top, 10)
              }
            }
            
            Circle()
              .stroke(Color.customOrange, lineWidth: 6)
              .frame(width: 350)
          }
          
          Spacer()
            .frame(height: 10)
          
          HStack {
            Button(
              action: {
                timerViewModel.cancelBtnTapped()
              },
              label: {
                Text("취소")
                  .font(.system(size: 16))
                  .foregroundColor(.customBlack)
                  .padding(.vertical, 25)
                  .padding(.horizontal, 22)
                  .background(
                    Circle()
                      .fill(Color.customGray2.opacity(0.3))
                  )
              }
            )
            
            Spacer()
            
            Button(
              action: {
                timerViewModel.pauseOrRestartBtnTapped()
              },
              label: {
                Text(timerViewModel.isPaused ? "계속진행" : "일시정지")
                  .font(.system(size: 14))
                  .foregroundColor(.customBlack)
                  .padding(.vertical, 25)
                  .padding(.horizontal, 7)
                  .background(
                    Circle()
                      .fill(Color(red: 1, green: 0.75, blue: 0.52).opacity(0.3))
                  )
              }
            )
          }
          .padding(.horizontal, 20)
        }
      }
    }

#Preview {
    TimerView()
}
