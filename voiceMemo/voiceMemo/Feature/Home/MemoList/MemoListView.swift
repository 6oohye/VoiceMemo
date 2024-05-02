//
//  MemoListView.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/1/24.
//

import SwiftUI

//프리뷰로 확인하고싶을 때 프리뷰에도 .environmentObject 넣어주는거 잊지말기 !

struct MemoListView: View {
    //todoView자체를 같이 스택에 쌓고 해야하니 pathModel필요
    @EnvironmentObject private var pathModel : PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    //같이 상태를 공유하고 전역적으로 사용해야하니 @EnvironmentObject로 가져감.
    
    var body: some View {
        ZStack{
            VStack{
                //커스텀네이게이션바 얹혀주기
                if !memoListViewModel.memos.isEmpty{
                    CustomNavigationBar(
                        isDisplayLeftBtn: false, //뒤로가기로 보여줄게 없으니,
                        rightBtnAction:{
                            memoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType: memoListViewModel.navigationBarRigthBtnMode
                    )
                }else{
                    Spacer()
                        .frame(height: 30)
                }
                //타이틀뷰
                TitleView()
                    .padding(.top, 20)
                
                //안내뷰 혹은 메모 리스트 컨텐츠뷰
                if memoListViewModel.memos.isEmpty{
                    AnnouncementView()
                }else{
                    MemoListContentView()
                        .padding(.top,20)
                }
            }
            //메모작성 아이콘 버튼 뷰
            WriteMemoBtnView()
                .padding(.trailing,20)
                .padding(.bottom, 50)
        }
        .alert(
            "메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?",
            isPresented:$memoListViewModel.isDisplayRemoveMemoAlert
            //$ 표시는 SwiftUI에서 바인딩을 나타내는 것입니다. SwiftUI는 상태를 관리하고 표현하기 위해 바인딩을 사용합니다. 바인딩은 특정 상태의 변경을 추적하고 이를 UI에 반영하는 역할을 합니다.
            
            // isPresented는 어떤 상태를 나타내는데, 여기서는 어떤 알림창이 표시되고 있는지를 나타냅니다. 따라서 $를 사용하여 이 상태에 대한 바인딩을 제공합니다. 이렇게 하면 상태가 변경될 때 UI가 자동으로 업데이트됩니다.
            
            //즉, $를 사용하면 상태 변화에 따라 UI가 자동으로 업데이트되므로 UI와 상태 간의 동기화가 보장됩니다.
        ){
            Button("삭제", role: .destructive){
                memoListViewModel.removeBtnTapped()
            }
            Button("취소", role: .cancel){}
        }
    }
}

//MARK: - 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack{
            if memoListViewModel.memos.isEmpty{
                Text("메모를\n추가해 보세요.")
            }else{
                Text("메모\(memoListViewModel.memos.count)개가\n있습니다.")
            }
            Spacer() //오른쪽 공간엔 최대로 스페이스 차지
        }
        .font(.system(size: 30,weight: .bold))
        .padding(.leading, 20)
    }
}

//MARK: - 안내뷰
private struct AnnouncementView: View {
    //뷰모델이 필요없음
    fileprivate var body: some View {
        VStack(spacing:15){
            Spacer()
            
            Image("pencil")
                .renderingMode(.template) //색상변경을 위해 랜더링모드를 템플릿으로 가져감
            Text("\"퇴근 9시간 전 메모\"")
            Text("\"개발 끝낸 후 퇴근하기\"")
            Text("\"밀린 알고리즘 공부하기!\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2) //이렇게하면 폰트 아이콘 동시에 색깔 변함(위에 랜더링걸어줘서)
    }
}

//MARK: - 메모 리스트 컨텐츠뷰
private struct MemoListContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    var body: some View {
        VStack{
            HStack{
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical){
                VStack(spacing: 0){
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    ForEach(memoListViewModel.memos, id: \.self){memo in
                        MemoCellView(memo: memo)
                    }
                }
            }
        }
    }
}

//MARK: - 메모 셀 뷰 만들기
private struct MemoCellView: View {
    @EnvironmentObject private var pathModel: PathModel //뷰어타입에서 뷰어를 메모뷰로 올려야하기때문에
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool //삭제되는 체크박스 표시를 위해서
    private var memo: Memo //얘가 어떤 메모인지.
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        memo: Memo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button (
            action: {
                pathModel.paths.append(.memoView(isCreatMode: false, memo: memo))
            },
            label: {
                VStack{
                    HStack{
                        VStack(alignment:.leading){
                            Text(memo.title)
                                .lineLimit(1)
                                .font(.system(size: 16))
                                .foregroundColor(.customBlack)
                            Text(memo.content)
                                .font(.system(size: 12))
                                .foregroundColor(.customIconGray)
                        }
                        Spacer()
                        
                        //오른쪽에 체크박스 구성
                        if memoListViewModel.isEditMemoMode{
                            Button {
                                isRemoveSelected.toggle()
                                memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                            } label: {
                                isRemoveSelected ? Image("selectBox") : Image("unSelectBox")
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                }
            }
        )
    }
}

//MARK: - 메모 작성 뷰
private struct WriteMemoBtnView: View {
    @EnvironmentObject private var pathmodel: PathModel
    //실제로 넘어가야하니 스택을 쌓아주기위한 패스모델 필요
    
    fileprivate var body: some View {
        VStack{
            Spacer()
            
            HStack{
                Spacer()
                
                Button(
                    action:{
                        pathmodel.paths.append(.memoView(isCreatMode: true, memo: nil))
                    },
                    label: {
                        Image("writeBtn")
                    }
                )
            }
        }
    }
}




#Preview {
    MemoListView()
        .environmentObject(PathModel())
        .environmentObject(MemoListViewModel())
}
