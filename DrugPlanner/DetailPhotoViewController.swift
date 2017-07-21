//
//  DetailPhotoViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {

    @IBOutlet var detailedImageView: UIImageView!
    var getImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailedImageView.image = getImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
