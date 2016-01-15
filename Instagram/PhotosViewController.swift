//
//  ViewController.swift
//  Instagram
//
//  Created by John Henning on 1/14/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    var popular : [NSDictionary]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        callApi()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callApi() {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.popular = responseDictionary["data"] as? [NSDictionary]
                            NSLog("response: \(responseDictionary)")
                    }
                }
                self.tableView.reloadData()
        });
        task.resume()
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let popular = popular{
            return popular.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("popular", forIndexPath: indexPath) as! PopularCell
        
        let picture = popular[indexPath.row]
        
    
        let picURL = NSURL(string: picture["images"]!["standard_resolution"]!!["url"] as! String)
        let profpicURL = NSURL(string: picture["user"]!["profile_picture"] as! String)
        
        
        
        let username = picture["user"]!["username"] as! String
        print(username)
        cell.usernameView.text = username
        cell.pictureView.setImageWithURL(picURL!)
        cell.profilePictureView.setImageWithURL(profpicURL!)
        return cell
    }

}

