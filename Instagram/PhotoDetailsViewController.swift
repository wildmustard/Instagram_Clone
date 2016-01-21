//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Alex Clark on 1/21/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet var pictureView: UIImageView!
    
    var popular: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let picURL = NSURL(string: popular["images"]!["standard_resolution"]!!["url"] as! String)
        
        pictureView.setImageWithURL(picURL!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
