//
//  ViewController.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/13/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FeedModelDelegate {

    let feedModel: FeedModel = FeedModel()
    var articles:[Article] = [Article]()
    var selectedArticle: Article?
    let imageQueue = NSOperationQueue()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set itself as the delegate for the feedModel
        self.feedModel.delegate = self
        
        //Fire off request to DL articles in background, dont wait to set it to articles array.
        self.feedModel.getArticles()
        
        //Add Icon to nav item title bar
        let titleIcon:UIImageView = UIImageView(frame: CGRectMake(0, 0, 33, 33))
        titleIcon.image = UIImage(named: "JalopnikIcon")
        self.navigationItem.titleView = titleIcon
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Get reference to destination VC
        let detailViewController = segue.destinationViewController as! DetailViewController
        //Pass along selected article
        detailViewController.articleToDisplay = self.selectedArticle
    }
    
    func articlesReady() {
        self.articles = self.feedModel.articles
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedArticle = self.articles[indexPath.row]
        performSegueWithIdentifier("toDetailSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.tag += 1
        let tag = cell.tag
        cell.articleTitleLabel.text = article.articleTitle
        imageQueue.addOperationWithBlock { 
            if let image = ImageDownloader.downloadImage(article) {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if cell.tag == tag {
                        cell.articleImageView.image = image
                    }
                })
            }

        }
        return cell 
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    //Swipe to show share features in tableviewRow
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareRowAction = UITableViewRowAction(style: .Normal, title: "Share") { (action, index) in
            let activityViewController = UIActivityViewController(activityItems: [self.articles[indexPath.row].articleLink], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        //TODO: Add a favorite feature? How to persist? BackEnd? How to save a struct?
        
        shareRowAction.backgroundColor = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        return [shareRowAction]
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
//        let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
//            print("more button tapped")
//        }
//        more.backgroundColor = UIColor.lightGrayColor()
//        
//        let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
//            print("favorite button tapped")
//        }
//        favorite.backgroundColor = UIColor.orangeColor()
//        
//        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
//            print("share button tapped")
//        }
//        share.backgroundColor = UIColor.blueColor()
//        
//        return [share, favorite, more]
//    }
}