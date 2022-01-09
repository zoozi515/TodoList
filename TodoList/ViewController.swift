//
//  ViewController.swift
//  TodoList
//
//  Created by administrator on 08/01/2022.
//

import UIKit
import CoreData //#0 import for presistance


class ViewController: UITableViewController {
    
    //#4 Create context object and use it to save changes
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //#3 Create an Array of Entity to presist data
    var notes: [NoteEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        /*set the title of title bar*/
        navigationController?.navigationBar.topItem?.title = "ToDo's List App"
        /*set the cell hieght*/
        tableView.rowHeight = 100
        
        //# To get the updated data after any change
        fetchAllNotes()
    }

    //#1 Set the number of cells shown in the app screen
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    //#2 Set the data to the cell attributes
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! CustomViewCell
        cell.noteLabel?.text = notes[indexPath.row].noteTitle
        cell.descriptionLabel?.text = notes[indexPath.row].noteNescription
        cell.dateLabel?.text = notes[indexPath.row].noteDate
        cell.checkmarkImg.isHidden = notes[indexPath.row].isHidden
        return cell
    }
    
    //#7 Update note
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           updateItem(path: indexPath.row)
           tableView.reloadData()
    }
    
    //#8 Delete note
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           deleteItem(path: indexPath.row)
           tableView.reloadData()
    }
    
    //#9 Get saved data
    func fetchAllNotes() {
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
            
        do {
            let result = try managedObjectContext.fetch(itemRequest)
            /*get and set the stored notes to my notes array*/
            notes = result as! [NoteEntity]
            } catch {
                print("\(error)")
            }
        tableView.reloadData()
    }
    
    //#10 Implement Update (Coredata)
    func updateItem(path: Int){
           //let context = getUpdatedContext()
           notes[path].isHidden.toggle()

           do{
               try managedObjectContext.save()
           }catch{
               print(error.localizedDescription)
           }
       }
    
    //#11 Implement Delete
    func deleteItem(path: Int){
        //let context = getUpdatedContext()
        
        managedObjectContext.delete(notes[path])
        notes.remove(at: path)
        
        do{
            try managedObjectContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //#12
    
    //#5 Move to add note VC
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        /*Create the vc obj*/
        let addNoteVC =  storyboard?.instantiateViewController(identifier: "addNoteVC") as! AddNotesViewController
        
        /*Set the delegate*/
        addNoteVC.addNoteDelegate = self
        
        /*Push to AddNoteVC*/
        self.navigationController?.pushViewController(addNoteVC, animated: true)
    }
}

//#6 Implement the protocol
extension ViewController: AddNoteDelegate{
    func addNote(title: String, description: String, date: String) {
        let note = NSEntityDescription.insertNewObject(forEntityName: "NoteEntity", into: managedObjectContext) as! NoteEntity
        note.noteTitle = title
        note.noteNescription = description
        note.noteDate = date
        note.isHidden = true
                
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        self.fetchAllNotes()
    }
    
    func cancelButtonPressed(with viewContoller: UIViewController) {
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)/*hide the view*/
    }
}

