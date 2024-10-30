//
//  CoreDataManager.swift
//  APIs
//
//  Created by Вадим Мартыненко on 14.10.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    // Code Data Manager
    init(){
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do{
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
