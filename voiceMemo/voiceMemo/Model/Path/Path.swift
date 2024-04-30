//
//  Path.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import Foundation

class PathModel:ObservableObject{
    @Published var paths : [PathType]
    
                            //초기값은 빈배열
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
