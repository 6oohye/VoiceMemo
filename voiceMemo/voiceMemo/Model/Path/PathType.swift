//
//  PathType.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

//네비게이션스택을 만들기위해..!
enum PathType:Hashable{
    case homeView
    case todoView
    case memoView(isCreatMode: Bool, memo: Memo?)
    //크리에이터 모드다 하면 생성화면을 띄어주고 크리에이터모드가 아니다하면 뷰어나 편집하는 화면 띄우기
}
