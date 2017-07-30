//
//  HistoryViewController.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin and Ioana :)))) huhuhuh on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit
import MessageUI

class HistoryViewController: UITableViewController {

    var items = [HistoryItem]()
    
    var observer : Any?
    
    var expandedRows = Set<Int>()
    
    var alertController : UIAlertController?
    
    var takenIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: HistoryStrings.HISTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
        
        items = History.instance.items!
        tableView.reloadData()
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // - History Table view data source - the already intaken Drugs

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
   
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryContentTableViewCell
        let historyItem = items[indexPath.row]
        cell.historyitem = historyItem
        
        
        // DATE AND TIME AUSFÜLLEN
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        cell.TimeOfTakeLabel.text = formatter.string(from: historyItem.dateAndTime)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.DateOfTakeLabel.text = formatter.string(from: historyItem.dateAndTime)
        
        //DRUG NAME
        cell.DrugNameLabel.text = historyItem.drugName
        
        //INTAKEN DOSE LABEL
        cell.DoseLabel.text = String(historyItem.intakenDose)
        
        //DOSE UNIT LABEL AUSFÜLLEN
        cell.DoseUnitLabel.text = getDrugTypeDescriptions(for: DrugType(rawValue: historyItem.drugType!)!)["amountUnit"]! + " a \(historyItem.drugConcentration!)" + getDrugTypeDescriptions(for: DrugType(rawValue: historyItem.drugType!)!)["doseUnit"]!
        
        //ACCESSORY VIEW IMAGE
        if historyItem.taken {
            cell.takenSwitch.setOn(true, animated: true)
            let image = #imageLiteral(resourceName: "OK") // checked 
            cell.accessoryView = UIImageView(image: image)
        }
        else {
            let image = #imageLiteral(resourceName: "Cancel") //- not; checked
            cell.takenSwitch.setOn(false, animated: true)
            cell.accessoryView = UIImageView(image :image)
        }
        
        cell.historyNoteTextField.text = historyItem.notes!
        
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        
        
        return cell
 
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? HistoryContentTableViewCell
            
            else { return }
        switch cell.isExpanded{
            case true:
                self.expandedRows.remove(indexPath.row)
            
            case false:
                self.expandedRows.insert(indexPath.row)
        }
        
        cell.isExpanded = !cell.isExpanded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let markChange = UITableViewRowAction(style: .normal, title: "Change?", handler: {
            action, index in
            //print("\(self.items[index.row].InventoryItemName) as taken")
            self.takenIndex = index.row
            self.historyDrugTakenTapped(index.row)
        })
        
        markChange.backgroundColor = UIColor(colorLiteralRed: 0.15294117647058825
            , green: 0.6823529411764706, blue: 0.3764705882352941, alpha: 1)
        
        return [markChange]
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if self.observer == nil {
            self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: HistoryStrings.HISTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
            
            items = History.instance.items!
            tableView.reloadData()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        if let obs = self.observer {
            NotificationCenter.default.removeObserver(obs)
            self.observer = nil
        }
        
    }
    
    @IBAction func editHistoryItem(_ sender: UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview as? HistoryContentTableViewCell {
            cell.historyitem?.notes = cell.historyNoteTextField.text
            History.instance.edit(historyItem: cell.historyitem!)
            
        }
    }
    
    
    @IBAction func deleteHistoryItem(_ sender: UIButton) {
        

        if let cell = sender.superview?.superview?.superview?.superview as? HistoryContentTableViewCell {
            History.instance.remove(historyItem: cell.historyitem! )
           
            
        }
        
    }
    
    @IBAction func saveNewHistoryItem (segue : UIStoryboardSegue) {
        
        if let createHistoryController = segue.source as? CreateHistoryItemController {
    
                History.instance.add(historyItem: createHistoryController.historyItem!)
            
        }
        
    }
    
    //DELETE HISTORY ITEM - brauchen wir ein Delete zu implementieren?
    
    
    
    @IBAction func cancelCreateHistoryEvent(segue:UIStoryboardSegue) {
    }
    
    
    func historyDrugTakenTapped (_ index: Int) {
        
        
        self.alertController = UIAlertController(title: "Are you sure you want to change the state to (not) taken?", message: "This will change the state", preferredStyle: .alert)
        
        
        let alertConfirmAction = UIAlertAction(title: "YES", style: .default, handler: {
            action in
            
            let historyItem = self.items[index]
            if historyItem.taken == true{
            historyItem.taken = false
            }else{
                historyItem.taken = true
            }
            History.instance.edit(historyItem: historyItem)
        
        })
        
        
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController!.addAction(alertConfirmAction)
        alertController!.addAction(alertCancelAction)
        
        present(alertController!, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func ExportToPDF(_ sender: UIButton) {
        
        let priorBounds: CGRect = self.tableView.bounds
        let fittedSize: CGSize = self.tableView.sizeThatFits(CGSize(width: priorBounds.size.width, height: self.tableView.contentSize.height))
        //self.tableView.bounds = CGRect(x: 0, y: 0, width: fittedSize.width, height: fittedSize.height)
        
        self.tableView.reloadData()
        let pdfPageBounds: CGRect = CGRect(x: 0, y: 0, width: fittedSize.width, height: (fittedSize.height))
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
        self.tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndPDFContext()

        
        let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let documentsFileName = documentDirectories! + "/" + "pdfName.pdf"
       // let documentsFileName = "Users/ioana-pica/Desktop" + "/" + "pdfNameWir.pdf"
        
        pdfData.write(toFile: documentsFileName, atomically: true)
        print(documentsFileName)
        
        
        self.alertController = UIAlertController(title: "Send the PDF Data in Email?", message: "This will attach the PDF to the email", preferredStyle: .alert)
        
        
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let alertConfirmAction = UIAlertAction(title: "YES", style: .default, handler: {
            action in
        
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: documentsFileName){
                
                let document = NSData(contentsOfFile: documentsFileName)
                //let pdfstring:String = document!.base64EncodedString(options: .endLineWithLineFeed)
                
                
                
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: ["Intaken Drugs sent from the app", document!], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView=self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            else {
                print("document was not found")
            }
            
            
            
        })
        
        alertController!.addAction(alertConfirmAction)
        alertController!.addAction(alertCancelAction)
        
        present(alertController!, animated: true, completion: nil)

    }
    
    
    
    // JUST A TRY
    /*
    func generatePdf(string: String) throws -> CGPDFDocument {
        
        guard let
            
            data = string.data(using: String.Encoding.utf8, allowLossyConversion: false),
            let cfData = CFDataCreate(CFAllocator as! CFAllocator!, <#T##bytes: UnsafePointer<UInt8>!##UnsafePointer<UInt8>!#>, data.count)
            
           // let cfData = CFDataCreate(kCFAllocatorDefault, UnsafePointer<UInt8>(data.bytes), data.length)
            else {
                print("")
            }
        
        let cgDataProvider =  CGDataProvider(data: cfData)
        
        guard let cgPDFDocument = CGPDFDocument(cgDataProvider!) else {
            
        }
        
        return cgPDFDocument
    }
    */
    func listDidUpdate(notification: Notification) {
        
        self.items = History.instance.items!
        self.tableView.reloadData()
        
    }
 
 
    
}
