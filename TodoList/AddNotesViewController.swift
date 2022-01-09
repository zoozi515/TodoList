//
//  AddNotesViewController.swift
//  TodoList
//
//  Created by administrator on 08/01/2022.
//

import UIKit

class AddNotesViewController: UIViewController {

    //#1 Declare the views
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //#3 Declare the delegate
    weak var addNoteDelegate: AddNoteDelegate?
    
    //#4 Declare the notes variables
    var currentDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //#5 Set title
        //self.navigationController?.navigationBar.topItem?.title = "Add Item"
        
        /*Make the text view not scrolled*/
        descriptionTextView.isScrollEnabled = false
        
    }
       
    //#6 Go back to previous VC
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        addNoteDelegate?.cancelButtonPressed(with: self)
    }
    
    //#7 Add the new note
    @IBAction func addItemButtonPressed(_ sender: Any) {
        appenedElement()
    }
    
    //8 Add the note using delegate
    func appenedElement(){
        /*Get the current values from text view and text field*/
        guard let noteTitle = titleTextField.text, noteTitle != "" else {
            return
        }
        guard let noteDescription = descriptionTextView.text, noteDescription != "" else {
            return
        }

        if let currentDate = currentDate {
            /*Pass data to delegate function*/
            addNoteDelegate?.addNote(title: noteTitle, description: noteDescription, date: currentDate)
            /*Go back*/
            addNoteDelegate?.cancelButtonPressed(with: self)
        }else{
           /*Set the date*/
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = DateFormatter.Style.short
           currentDate = dateFormatter.string(from: datePicker.date)
           
            /*Pass data to delegate function*/
            addNoteDelegate?.addNote(title: noteTitle, description: noteDescription, date: currentDate!)
            /*Go back*/
            addNoteDelegate?.cancelButtonPressed(with: self)
       }
    }
    
    //#9 Get the value from date picker
    @IBAction func datePickreChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        currentDate = dateFormatter.string(from: datePicker.date)
    }
    
    //#10 Create Alert Message
    func createAlert(message: String){
            let alert = UIAlertController(title: "Fields cannot be empty", message: "Please fill out the \(message) field in order to make a ToDo item", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(alert, animated: true)
    }
}

//#Create the protocol for adding elements
protocol AddNoteDelegate: class {
    func addNote(title: String, description: String, date: String)
    func cancelButtonPressed(with viewContoller: UIViewController)}
