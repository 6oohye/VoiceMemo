//
//  MemoListViewModel.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/1/24.
//


import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos :[Memo] //메모들에 대한 프로퍼티
    @Published var isEditMemoMode : Bool //두가지 모드 존재 1. 편집되는화면과, 2.편집이 다 된 완료화면
    @Published var removeMemos : [Memo]
    @Published var isDisplayRemoveMemoAlert: Bool
    
    var removeMemoCount: Int{
        return removeMemos.count
    }
    
    var navigationBarRigthBtnMode: NavigationBtnType{
        isEditMemoMode ? .complete : .edit
    }
    
    init(
        memos: [Memo] = [],
        isEditMemoMode: Bool = false,
        removeMemos: [Memo] = [],
        isDisplayRemoveMemoAlert: Bool = false
    ) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.removeMemos = removeMemos
        self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
    }
}

extension MemoListViewModel{
    func addMemo(_ memo: Memo){
        memos.append(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) { //memo모델에서 줬던 아이디값이 여기서 비교할 때 사용됨.
            memos[index] = memo
        }
    }
    
    func removeMemo(_ memo :Memo){
        if let index = memos.firstIndex(where: {$0.id == memo.id}){
            memos.remove(at: index)
        }
    }
    
//네비게이션바 쪽으로 가기.
   func navigationRightBtnTapped(){
       if isEditMemoMode{
           if removeMemos.isEmpty{
               isEditMemoMode = false
           }else{
               //삭제 얼럿 상태 값 변경을 위한 메소드 호출
               setIsDisplayRemoveMemoAlert(true)
           }
       }else{
           isEditMemoMode = true
       }
   }
   
   func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool){
       isDisplayRemoveMemoAlert = isDisplay
   }
   
   func memoRemoveSelectedBoxTapped(_ memo: Memo){
       if let index = removeMemos.firstIndex(of: memo){
           removeMemos.remove(at: index)
       }else{
           removeMemos.append(memo)
       }
   }
   
   func removeBtnTapped(){
       memos.removeAll{memo in
           removeMemos.contains(memo)}
       removeMemos.removeAll()
       isEditMemoMode = false
   }
   
}
