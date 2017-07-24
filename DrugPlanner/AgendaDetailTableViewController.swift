//
//  InventoryDetailTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 28.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class AgendaDetailTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var doseDetail: UILabel!
    @IBOutlet weak var doseDetailLabel: UILabel!
    @IBOutlet weak var notesDetail: UILabel!
    @IBOutlet weak var daysDetail: UILabel!
    @IBOutlet weak var timeDetail: UILabel!
    @IBOutlet weak var lastDayDetail: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    let daysLabelPrefix = "Take on "
    let daysLabelDefault = "No Days"

    var item : AgendaItem!
    
    let dateF : DateFormatter = DateFormatter()
    
    var observer : Any?
    
    var firebaseListener : UInt!
    
    var weekdays : [AgendaItem.Weekday : Bool]? {
        didSet {
            weekdaysSet()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // CONFIGURE DATE FORMATTER
//        dateF.dateStyle = .medium
//        dateF.timeStyle = .none
//        
//        // SET FIELDS TO INVENTORY ITEM VALUES
//        updateFields()
//        
//        // GET DESCRIPTIONS FOR INVENTORY ITEM TYPE
        let descriptions = getDrugTypeDescriptions(for: item.agendaDrug.InventoryItemType)
        nameDetail.text = item.agendaDrug.InventoryItemName
        doseDetail.text = String(item.agendaDose)
        doseDetailLabel.text = descriptions["amountUnit"]!
        daysDetail.text = daysLabelDefault
        weekdays = item.agendaWeekdays
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        timeDetail.text = formatter.string(from: item.agendaTime)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        lastDayDetail.text = formatter.string(from: item.agendaEndDate)


        notesDetail.text = item.agendaDrug.InventoryItemNotes
        if item.agendaDrug.InventoryItemPhoto != "" {
            imageView.image = item.agendaDrug.convertStringToImage(photoAsString: item.agendaDrug.InventoryItemPhoto)
        }
//        amountDetailLabel.text = descriptions["amountUnit"]!
//
//        
//        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.ITEM_UPDATE.appending(item.InventoryItemKey)), object: nil, queue: nil, using: inventoryItemDidChange)
//        
//        self.firebaseListener = Inventory.instance.listenToChanges(in: self.item)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func weekdaysSet() {
        
        var dayString = daysLabelPrefix
        
        for weekdayIndex in 1...7 {
            
            let weekday = AgendaItem.getWeekday(for: weekdayIndex)
        
            if let boolean = (weekdays?[weekday]) {
                print(boolean)
                if(boolean){
                    if(dayString == daysLabelPrefix) {
                        dayString += weekday.rawValue
                    } else {
                        dayString += ", " + weekday.rawValue
                    }
                    
                }
            }
            
        }
        
        if (dayString != daysLabelPrefix) {
            print("Test")
            print(dayString)
            daysDetail.text = dayString
        } else {
            daysDetail.text = daysLabelDefault
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "AgendaEdit") {
            let selectedItem = item
            if let destination = segue.destination as? UINavigationController {
                if let topDestination = destination.topViewController as? AgendaEditController{
                    topDestination.item = selectedItem
                }
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
//        if self.observer == nil {
//            self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.ITEM_UPDATE.appending(item.InventoryItemKey)), object: nil, queue: nil, using: inventoryItemDidChange)
//        }
//        
//        if self.firebaseListener == nil {
//            self.firebaseListener = Inventory.instance.listenToChanges(in: self.item)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
//        Inventory.instance.stopListening(to: item, using: self.firebaseListener)
//        self.firebaseListener = nil
//        
//        if let obs = self.observer {
//            NotificationCenter.default.removeObserver(obs)
//            self.observer = nil
//        }
        
        
    }

    
    func agendaItemDidChange(notification: Notification) {
        
//        self.item = Agenda.instance.items?.getItem(with: self.item.agendaKey)
        updateFields()
        
    }
    
    @IBAction func cancelAgendaItem (segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func editAgendaItem (segue : UIStoryboardSegue) {

        if let editController = segue.source as? AgendaEditController {
            
            Agenda.instance.edit(editController.item)
            
        }
        
    }
    
    private func updateFields() {
        
        nameDetail.text = item.agendaDrug.InventoryItemName

        doseDetail.text = String(item.agendaDose)

        notesDetail.text = item.agendaDrug.InventoryItemNotes
        if item.agendaDrug.InventoryItemPhoto != "" {
            imageView.image = item.agendaDrug.convertStringToImage(photoAsString: item.agendaDrug.InventoryItemPhoto)
        }
        
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        if (URL.scheme == "tel"){
            let phoneNumber = URL.absoluteString?.replacingOccurrences(of: "tel:", with: "")
            let alert = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (alert) in
                if UIApplication.shared.canOpenURL(URL as URL) {
                    UIApplication.shared.openURL(URL as URL)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
                print("User Canceld")
            }))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleToFill
        newImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    
    
    
}
