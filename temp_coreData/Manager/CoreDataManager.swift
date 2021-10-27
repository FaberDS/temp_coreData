//
//  CoreDataManager.swift
//  temp_coreData
//
//  Created by Denis Schüle on 26.10.21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    //Singleton
    static let shared = CoreDataManager()
    private init(){}
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "temp_coreData")
        container.loadPersistentStores { (storeDescription,error) in
            if let error = error {
                fatalError("# Error: \(error)")
            }
        }
        return container
    }()
    
    func addPerson(name:String){
        let person = Person(context: persistentContainer.viewContext)
        person.name = name
        saveContext()
    }
    func removePerson(person: Person){
        persistentContainer.viewContext.delete(person) // Because every CoreData Entity inherit the NSObject class it can easily be deleted
        saveContext()
    }
    
    var allPersons : [Person] {
        
        return (try? persistentContainer.viewContext.fetch(allPersonsFetchRequest())) ?? []
    }
    
    func allPersonsFetchRequest()->NSFetchRequest<Person>{
        let fetchRequest : NSFetchRequest<Person> = NSFetchRequest(entityName: "Person")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Person.name, ascending: true)]
        return fetchRequest
    }
    
    
    private func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("#Error: \t\(error)")
            }
        }
    }
}
