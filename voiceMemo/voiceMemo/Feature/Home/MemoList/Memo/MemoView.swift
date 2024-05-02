//
//  MemoView.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject var memoViewModel : MemoViewModel
    @State var isCreateMode : Bool = true
    
    var body: some View {
        ZStack{
            VStack{
                CustomNavigationBar(
                    leftBtnAction: {
                        pathModel.paths.removeLast()
                    },
                    rightBtnAction: {
                        if isCreateMode{
                            memoListViewModel.addMemo(memoViewModel.memo)
                        }else{
                            memoListViewModel.updateMemo(memoViewModel.memo)
                        }
                        pathModel.paths.removeLast()
                    },
                    rightBtnType: isCreateMode ? .create : .complete
                )
                
                //메모 타이블 인풋 뷰
                MemoTitleInputView(
                    memoViewModel: memoViewModel,
                    isCreatedMode: $isCreateMode
                )
                .padding(.top,20)
                //메모 컨텐츠 인풋 뷰
                MemoContentInputView(memoViewModel: memoViewModel)
                    .padding(.top,10)
            }
            //삭제 플로팅 버튼 뷰
            if !isCreateMode{
                RemoveMemoBtnView(memoViewModel: memoViewModel)
                    .padding(.trailing,20)
                    .padding(.bottom,10)
            }
        }
    }
}
//MARK: - 메모 제목 입력 뷰
private struct MemoTitleInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocused: Bool
    @Binding private var isCreatedMode: Bool
    
    fileprivate init(
        memoViewModel: MemoViewModel,
        isCreatedMode: Binding<Bool> //바인딩이라서 바인딩값으로 변수를 잡아줘야함
    ) {
        self.memoViewModel = memoViewModel
        self._isCreatedMode = isCreatedMode  //바인딩이라 언더바를 사용해 셀프에 값을 넣음
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요",
                  text: $memoViewModel.memo.title
        )
        .font(.system(size: 30))
        .padding(.horizontal,20)
        .focused($isTitleFieldFocused)
        .onAppear{
            if isCreatedMode{
                isTitleFieldFocused = true
            }
        }
    }
}
//MARK: - 메모 본문 입력 뷰
private struct MemoContentInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading){
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))
            
            if memoViewModel.memo.content.isEmpty{
                Text("메모를 입력하세요")
                    .font(.system(size: 16))
                    .foregroundStyle(.customGray1)
                    .allowsHitTesting(false) //false를 주면 터치가 먹지않음, 얘를 false줘서 TextEditor가 터치를 먹을 수 있도록 해줌
                    .padding(.top,10)
                    .padding(.leading,5)
                
            }
        }
        .padding(.horizontal,20)
    }
}
//MARK: - 메모 삭제 버튼 뷰
private struct RemoveMemoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init( memoViewModel: MemoViewModel
    ) {
        self.memoViewModel = memoViewModel
    }
    fileprivate var body: some View {
        VStack{
            Spacer()
            
            HStack{
                Spacer()
                Button(
                    action: {
                        memoListViewModel.removeMemo(memoViewModel.memo)
                        pathModel.paths.removeLast()
                    }
                    , label: {
                        Image("trash")
                            .resizable()
                            .frame(width: 40,height: 40)
                    }
                )
            }
        }
    }
}

#Preview {
    MemoView(
        memoViewModel: .init(
            memo: .init(
                title: "",
                content: "",
                date: Date()
            )
        )
    )
}
