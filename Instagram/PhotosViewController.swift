//
//  ViewController.swift
//  Instagram
//
//  Created by John Henning on 1/14/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    var popular : [NSDictionary]!
    var refreshControl : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        callApi()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.callApi()
            self.refreshControl.endRefreshing()
        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        callApi()
    }

    var isMoreDataLoading = false;
    
    
    func loadMoreData() {
        
        
        self.isMoreDataLoading = false
        
        callApi()
        
        
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(!isMoreDataLoading){
            
            let scrollViewContentHeight = tableView.contentSize.height;
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                loadMoreData()
                scrollView.contentOffset.y = 0
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let popular = popular{
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("popular", forIndexPath: indexPath) as! PopularCell
        
        let picture = popular[indexPath.section]
        let picURL = NSURL(string: picture["images"]!["standard_resolution"]!!["url"] as! String)
        
        cell.pictureView.setImageWithURL(picURL!)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let popular = popular{
            return popular.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 2, width: 25, height: 25))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        // Use the section number to get the right URL
        let picture = popular[section]
        profileView.setImageWithURL(NSURL(string: picture["user"]!["profile_picture"] as! String)!)
        
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username here
        let usernamelabel = UILabel(frame: CGRect(x: 60, y: 2, width: 200, height: 25))
        usernamelabel.clipsToBounds = true
        usernamelabel.text = picture["user"]!["username"] as? String
        headerView.addSubview(usernamelabel)
        return headerView

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        var vc = segue.destinationViewController as! PhotoDetailsViewController
        
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        vc.popular = popular[indexPath!.row]
        
        
    }
    

}

