//
//  OnboardingView.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/29/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        //TODO: - 화면전환 구현 필요
        OnboardingContentView(onboardingViewModel: onboardingViewModel)
    }
}

//MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject  private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View{
        VStack{
            //온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            //시작버튼 뷰
        }
    }
}

//MARK: - 온보딩 셀리스트뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int //온보딩 셀리스트뷰에는 탭뷰가 들어갈거기때문에 선언.
    
    fileprivate init(
        onboardingViewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View{
        TabView(selection: $selectedIndex){
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()),id: \.element) {index, OnboardingContent in
                OnboardingCellView(onboardingContent: OnboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) //스와이프 방식으로 넘기기
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0
            ? Color.customSky
            : Color.custombackgroundGreen
        )
        .clipped() //탭뷰를 사용할 때 잘리는 부분을 과감하게 절삭하기 위해서 사용.
    }
}

//MARK: - 온보딩 셀 뷰
fileprivate struct OnboardingCellView: View{
    private var onboardingContent: OnboardingContent
    
    fileprivate init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View{
        VStack{
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            HStack{
                Spacer()
                
                VStack{
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16,weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .background(Color.customWhite)
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}
    
    
    #Preview {
        OnboardingView()
    }

