//
//  ViewController.swift
//  coreData
//
//  Created by Denis Schüle on 26.10.21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
//      Required when not using NSFetchedResultController
//    private var persons : [Person] = Array<Person>() {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    lazy var personFetchResultController : NSFetchedResultsController<Person> = {
        let fetchRequest = CoreDataManager.shared.allPersonsFetchRequest()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        // SectionNameKeyPath can be used to group rows by a attribute
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialFetch()
        tableView.dataSource = self
        navigationItem.leftBarButtonItem = editButtonItem
        // Do any additional setup after loading the view.
        
    }
    func performInitialFetch(){
        do {
            try? personFetchResultController.performFetch()
        } catch {
            print("#Error: \t\(error.localizedDescription)")
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: true)
    }
   
    @IBAction func addButtonDidTap(_ sender: UIBarButtonItem) {
        CoreDataManager.shared.addPerson(name: "FRANZ \((0...99).randomElement()!)")
    }
    

}

extension ViewController : UITableViewDataSource {
    
    // Returns amount of item
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personFetchResultController.fetchedObjects?.count ?? 0
    }
    // defines each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = personFetchResultController.object(at: indexPath)
        //>iOS 14
        var content = cell.defaultContentConfiguration()
        content.text = "\(String(format: "%03d", (indexPath.row+1))) - \(person.name!)"
        content.image = UIImage(systemName: "person")
        cell.contentConfiguration = content
        // pre iOS 14
//        cell.textLabel?.text = persons[indexPath.row].name
//        cell.imageView?.image = UIImage(systemName: "person")
        return cell
    }
    // is called when table view cell is in editing mode
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = personFetchResultController.object(at: indexPath)
            CoreDataManager.shared.removePerson(person: person)
        }
    }
}

extension ViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()    }
}
