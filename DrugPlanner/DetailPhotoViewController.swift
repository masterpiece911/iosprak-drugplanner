//
//  DetailPhotoViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var detailedImageView: UIImageView!
    
    var image : UIImage? = UIImage()
    
    let deleteWarningAlert = UIAlertController(title: "Confirm Delete?", message: "This action can not be undone.", preferredStyle: .alert)
    
    let importMethodAlert = UIAlertController(title: nil, message: "Chose an image from", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: deleteConfirmed)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        deleteWarningAlert.addAction(okAction)
        deleteWarningAlert.addAction(cancelAction)
        
        let galleryAction = UIAlertAction(title: "Import from gallery", style: .default, handler: importFromGallery)
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: importFromCamera)
        
        importMethodAlert.addAction(galleryAction)
        importMethodAlert.addAction(cameraAction)
        importMethodAlert.addAction(cancelAction)
        
        detailedImageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func deletePhotoButton(_ sender: UIBarButtonItem) {

        present(deleteWarningAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func newPhotoButtonPressed (_ sender: UIBarButtonItem) {
        
        present(importMethodAlert, animated: true, completion: nil)
        
    }
    
    func deleteConfirmed (action: UIAlertAction) {
        
        self.image = nil
        performSegue(withIdentifier: "InventoryPhotoEdit", sender: self)
        
    }
    
    func importFromGallery (action: UIAlertAction) {
    
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = .photoLibrary
        
        image.allowsEditing = true
        self.present(image, animated: true)
        
    }
    
    func importFromCamera (action: UIAlertAction) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.allowsEditing = true
        image.sourceType = .camera
        
        image.cameraCaptureMode = .photo
        image.modalPresentationStyle = .fullScreen
        
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.image = image
            
        }
        
        //self.dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "InventoryPhotoEdit", sender: self)
        
    }
    
}
