//
//  CreateInventoryItemTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateInventoryItemTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var doseField: UITextField!
    @IBOutlet weak var amountUnitLabel: UILabel!
    @IBOutlet weak var doseUnitLabel: UILabel!
    @IBOutlet weak var expiryDatePicker: UITextField!
    @IBOutlet weak var noteField: UITextField!
    
    @IBOutlet weak var doctorNameField: UITextField!
    @IBOutlet weak var doctorPhoneField: UITextField!
   
    @IBOutlet weak var cellDoctorName: UITableViewCell!

    @IBOutlet weak var cellDoctorPhone: UITableViewCell!
    var photoString64: String?
    
    @IBAction func prescriptionNeededSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            doctorNameField.isEnabled = true;
            doctorPhoneField.isEnabled = true;
            doctorNameField.isUserInteractionEnabled = true;
            doctorPhoneField.isUserInteractionEnabled = true;
            
            cellDoctorName.isUserInteractionEnabled = true;
            cellDoctorPhone.isUserInteractionEnabled = true;
        }else{
            doctorNameField.isEnabled = false;
            doctorPhoneField.isEnabled = false;
            doctorNameField.isUserInteractionEnabled = false;
            doctorPhoneField.isUserInteractionEnabled = false;
            cellDoctorName.isUserInteractionEnabled = false;
            cellDoctorPhone.isUserInteractionEnabled = false;
        }
    }
    // Fotos Section
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = true
        self.present(image, animated: true)
    }
    
    @IBOutlet var myImageView: UIImageView!
    
    @IBAction func takeImage(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        
        image.cameraCaptureMode = .photo
        image.modalPresentationStyle = .fullScreen

        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImageView.image = image
        
            let imageData:NSData = UIImageJPEGRepresentation(image, 0.8)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            photoString64 = strBase64
            }
            
        else
        {
            // Display error
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    var type:String = "" {
        didSet {
            typeLabel.text? = type
            
            let descriptions = getDrugTypeDescriptions(for: DrugType(rawValue: type)!)
            
            amountUnitLabel.text = descriptions["amountUnit"]
            doseUnitLabel.text = descriptions["doseUnit"]
            
        }
    }
    
    var expiryDate : Date?
    
    let datePicker = UIDatePicker()
    var selDate: String?
    
    private var item : InventoryItem!
    
    var inventoryItem : InventoryItem {
        get {
            return item
        }
        set {
            item = newValue
        }
    }
    
    var dateF : DateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateF = DateFormatter()
        dateF.dateStyle = .medium
        dateF.timeStyle = .none
        
        createDatePicker()
        
        amountUnitLabel.text = ""
        doseUnitLabel.text = ""
        cellDoctorName.isUserInteractionEnabled = false;
        cellDoctorPhone.isUserInteractionEnabled = false;
        

        
        expiryDatePicker.addTarget(self, action: #selector(datePickerSelected), for: .editingDidBegin)
        expiryDatePicker.addTarget(self, action: #selector(datePickerUnselected), for: .editingDidEnd)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

        

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            nameField.becomeFirstResponder()

        case 2:
            amountField.becomeFirstResponder()
        case 3:
            doseField.becomeFirstResponder()
        case 4:
            expiryDatePicker.becomeFirstResponder()
        case 5:
            noteField.becomeFirstResponder()
        default:
            break
        }
    }
    

    func createDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
        expiryDatePicker.inputView = datePicker
    }
    
    func datePickerChanged() {
        expiryDatePicker.text = dateF.string(from: datePicker.date)
        expiryDate = datePicker.date
    }
    
    func datePickerSelected() {
        if let dPtext = expiryDatePicker.text {
            
            if let previousDate = dateF.date(from: dPtext) {
                datePicker.setDate(previousDate, animated: false)
                expiryDate = datePicker.date
            } else {
                datePicker.setDate(datePicker.minimumDate!, animated: false)
                expiryDatePicker.text = dateF.string(from: datePicker.date)
                expiryDate = datePicker.date
            }
        }
    }
    
    func datePickerUnselected() {
        if expiryDatePicker.text != "" && expiryDate != nil {
           expiryDate = datePicker.date
        } else {
           expiryDate = nil
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "PickType") {
            if let typePickerViewController = segue.destination as? ChooseTypeTableViewController {
                typePickerViewController.selectedType = type
            }
        } else if (segue.identifier == "SaveInventoryItem") {
            
            if let photostring = photoString64{
                item = InventoryItem(key: "test", name: nameField.text!, type: DrugType(rawValue: typeLabel.text!)!, amount: Int(amountField.text!)!, dose: Int(doseField.text!)!, expiryDate: expiryDate!,doctorName: doctorNameField.text!, doctorPhone: doctorPhoneField.text!, notes: noteField.text!, photo: photostring)} else {
                item = InventoryItem(key: "test", name: nameField.text!, type: DrugType(rawValue: typeLabel.text!)!, amount: Int(amountField.text!)!, dose: Int(doseField.text!)!, expiryDate: expiryDate!, doctorName: doctorNameField.text!, doctorPhone: doctorPhoneField.text!, notes: noteField.text!, photo: "")
            }
        }
        
    }
    
    @IBAction func unwindWithSelectedType(segue : UIStoryboardSegue) {
        if let typePickerViewController = segue.source as? ChooseTypeTableViewController {
            if let selectedType = typePickerViewController.selectedType {
                type = selectedType
                let descriptions = getDrugTypeDescriptions(for: DrugType(rawValue: type)!)
                amountUnitLabel.text = descriptions["amountUnit"]!
                doseUnitLabel.text = descriptions["doseUnit"]!
                
            }
        }
    }
    
    @IBAction func confirmInventory(_ sender: Any) {
        
        if (inventoryItemEntered()) {
            performSegue(withIdentifier: "SaveInventoryItem", sender: self)
        } else {
            let incompleteInventoryItemController = UIAlertController(title: "Incomplete Information", message: "Please fill out all fields before proceeding.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            incompleteInventoryItemController.addAction(okAction)
            
            present(incompleteInventoryItemController, animated: true, completion: nil)
        }
        
    }
    
    func inventoryItemEntered() -> Bool {
        
        var entered = true
        
        if let text = nameField.text, !text.isEmpty{
        } else {
            entered = false
        }
        if let text = amountField.text, !text.isEmpty {
        } else {
            entered = false
        }
        if let text = doseField.text, !text.isEmpty {
        } else {
            entered = false
        }
        if let text = expiryDatePicker.text, !text.isEmpty {
        } else {
            entered = false
        }
        
        if doctorNameField.isUserInteractionEnabled, let text = doctorNameField.text, !text.isEmpty{
            
        }else{
            entered = false;
        }
        
        if doctorPhoneField.isUserInteractionEnabled, let text = doctorPhoneField.text, !text.isEmpty{
            
        }else{
            entered = false;
        }
        if type == "" {
            entered = false
        }
        
        return entered
    }
    
    
    

}



