//
//  CoreDataManager.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/18.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let entityName = "TodoData"
    
    
    func fetchTodoDataFromCoreData() -> [TodoData] {
        var todoList = [TodoData]()
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            let mainOrder = NSSortDescriptor(key: "endDate", ascending: false)
            let subOrder = NSSortDescriptor(key: "creationDate", ascending: false)
            request.sortDescriptors = [mainOrder, subOrder]
            
            do {
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    todoList = fetchedTodoList
                }
            } catch {
                assertionFailure("TodoList 데이터를 가져오는 것에 실패했습니다.")
            }
        }
        return todoList
    }
    
    func saveTodoData(memo: String, endDate: Date, color: Int64, isSuccess: Bool, completion: @escaping () -> Void) {
        if let context = context {
            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { preconditionFailure() }
            guard let todoData = NSManagedObject(entity: entity, insertInto: context) as? TodoData else { preconditionFailure() }
            
            todoData.memo = memo
            todoData.creationDate = Date()
            todoData.endDate = endDate
            todoData.colors = color
            todoData.isSuccess = isSuccess
            
            if context.hasChanges {
                do {
                    try context.save()
                    completion()
                } catch {
                    print(error)
                    completion()
                }
            }
        }
        completion()
    }
    
    func deleteTodo(data: TodoData, completion: @escaping () -> Void) {
        let date = data.endDate
        let memo = data.memo
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = NSPredicate(format: "endDate = %@", date as CVarArg)
            request.predicate = NSPredicate(format: "memo = %@", memo)
            
            do {
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    guard let targetTodo = fetchedTodoList.first else { return }
                    context.delete(targetTodo)
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            } catch {
                assertionFailure("TodoList 데이터를 지우는 것에 실패했습니다.")
            }
        }
        completion()
    }
    
    func updateTodo(newTodoData: TodoData, completion: @escaping () -> Void) {
        let date = newTodoData.endDate

        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = NSPredicate(format: "endDate = %@", date as CVarArg)
            
            do {
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    guard var targetTodo = fetchedTodoList.first else { return }
                    targetTodo = newTodoData
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            } catch {
                assertionFailure("TodoList 데이터를 수정하는 것에 실패했습니다.")
            }
        }
        completion()
    }
}
