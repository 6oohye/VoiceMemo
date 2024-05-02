//
//  MemoViewModel.swift
//  voiceMemo
//
//  Created by 6혜진 on 5/1/24.
//

import Foundation

class MemoViewModel: ObservableObject {
  @Published var memo: Memo
  
  init(memo: Memo) {
    self.memo = memo
  }
}
