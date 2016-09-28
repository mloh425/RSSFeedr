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
    var favoriteArticles:[Article] = [Article]()
    var selectedArticle: Article?
    let imageQueue = OperationQueue()
    let refreshController = UIRefreshControl()
    
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
        let titleIcon:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        titleIcon.image = UIImage(named: "JalopnikIcon")
        self.navigationItem.titleView = titleIcon
        
        //Pull to refresh
        refreshController.tintColor = UIColor.orange
        refreshController.addTarget(self, action: #selector(ViewController.handleRefresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue" {
            //Get reference to destination VC
            let detailViewController = segue.destination as! DetailViewController
            //Pass along selected article
            detailViewController.articleToDisplay = self.selectedArticle
        } else if segue.identifier == "toFavorites" {
            let favoritesViewController = segue.destination as! FavoritesTableViewController
            //TODO: Set array of favorite articles to FTBVC's array of articles to display
            
        }
        
    }
    
    func articlesReady() {
        print("Refreshing")
        self.articles = self.feedModel.articles
        tableView.reloadData()
        self.refreshController.endRefreshing()
    }
    
    func handleRefresh() {
        self.feedModel.getArticles()
        self.tableView.reloadData()
    }

    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toFavorites", sender: self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedArticle = self.articles[indexPath.row]
        performSegue(withIdentifier: "toDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.tag += 1
        let tag = cell.tag
        cell.articleTitleLabel.text = article.articleTitle
        imageQueue.addOperation { 
            if let image = ImageDownloader.downloadImage(article: article) {
                OperationQueue.main.addOperation({ () -> Void in
                    if cell.tag == tag {
                        cell.articleImageView.image = image
                    }
                })
            }

        }
        return cell 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    //Swipe to show share features in tableviewRow
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareRowAction = UITableViewRowAction(style: .normal, title: "Share") { (action, index) in
            let activityViewController = UIActivityViewController(activityItems: [self.articles[indexPath.row].articleLink], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        //TODO: Add a favorite feature? How to persist? BackEnd? How to save a struct?
        
        shareRowAction.backgroundColor = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        
        let favoriteRowAction = UITableViewRowAction(style: .normal, title: "Favorite") { (action, index) in
            //TODO:
            //Some animation to highlight the cell? 
            //Add article to favorite array - Does this need to be a singleton? Or Stored into a cloud/backend?
            //A 'favorited' toggle property so user can deselect and remove
            //If not favorited, favorite it. Else Remove it and refresh tableView?
//            if self.articles[indexPath.row].articleFavorited == false {
//                self.favoriteArticles.append(self.articles[indexPath.row])
//                self.articles[indexPath.row].articleFavorited = true
//
//            } else {
//                //How to remove at index without going out of bounds?
//                self.articles[indexPath.row].articleFavorited = false
//                var indexOfRemoval = 0
//                for article in self.favoriteArticles {
//                    if article.articleTitle == self.articles[indexPath.row].articleTitle {
//                        self.articles.remove(at: indexOfRemoval)
//                    }
//                    indexOfRemoval += 1
//                }
//            }
            self.favoriteArticles.append(self.articles[indexPath.row])
        }
        
        return [shareRowAction, favoriteRowAction]
    }
}
