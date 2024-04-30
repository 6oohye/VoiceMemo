//
//  TodoListViewModel.swift
//  voiceMemo
//
//  Created by 6혜진 on 4/30/24.
//

import Foundation

class TodoListViewModel: ObservableObject{
    @Published var todos : [Todo]
    @Published var isEditTodoMode : Bool
    @Published var removeTodos : [Todo]
    @Published var isDisplayRemoveTodoAlert : Bool
    
    var removeTodosCount: Int{
        return removeTodos.count
    }
    
    var navigationBarRightBtnMode : NavigationBtnType{
        isEditTodoMode ? .complete : .edit
    }
    
    init(todos: [Todo] = [],
         isEditModeTodoMode: Bool = false,
         removeTodos: [Todo] = [],
         isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditModeTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

// 실제 로직은 잘 보일 수 있게 나눠서 extension에서 뽑아보겠음.
extension TodoListViewModel{
    func selectedBoxTapped(_ todo: Todo){
        if let index = todos.firstIndex(where: {$0 == todo}){ //먼저 현재 Todo를 찾기.
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(_ todo:Todo){
        todos.append(todo)
    }
    
    func navigationRightBtnTapped(){
        if isEditTodoMode{
            if removeTodos.isEmpty{
                isEditTodoMode = false
            }else{
               setIsDisplayRemoveTodoAlert(true)
            }
        }else{
            isEditTodoMode = true
        }
    }
    
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool){
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    func todoRemoveSelectedBoxTapped(_ todo :Todo){
        if let index = removeTodos.firstIndex(of: todo) {
              removeTodos.remove (at: index)
        }else{
            removeTodos.append(todo)
        }
    }
    
    func removeBtnTapped(){
        todos.removeAll{todo in //현재 보여지고 있는 todo에서
            removeTodos.contains(todo) //리무브투두스에 담긴 투두와 값이 일치하는 애들을 다 지워줌.
        }
        removeTodos.removeAll()
        isEditTodoMode = false
    }
    
}

