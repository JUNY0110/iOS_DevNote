//
//  TodoData+CoreDataProperties.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/15.
//
//

import Foundation
import CoreData


extension TodoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoData> {
        return NSFetchRequest<TodoData>(entityName: "TodoData")
    }

    @NSManaged public var creationDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var memo: String
    @NSManaged public var colors: Int64
    @NSManaged public var isSuccess: Bool

}

extension TodoData : Identifiable {

}
