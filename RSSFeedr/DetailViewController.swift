//
//  DetailViewController.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/13/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var articleToDisplay: Article?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Add Icon on Navigation bar
        let titleIcon:UIImageView = UIImageView(frame: CGRectMake(0, 0, 33, 33))
        titleIcon.image = UIImage(named: "JalopnikIcon")
        self.navigationItem.titleView = titleIcon

        if let actualArticle = self.articleToDisplay {
            //Create NSURL for article URL
            print(actualArticle.articleLink)
            let modifiedURL = actualArticle.articleLink.stringByReplacingOccurrencesOfString("http", withString: "https", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let url: NSURL? = NSURL(string: modifiedURL)
            //Create NSURL Request for NSURL
            if let actualUrl = url {
                let urlRequest: NSURLRequest = NSURLRequest(URL: actualUrl)
                self.webView.loadRequest(urlRequest)
            }
            //Pass request into webview to load page
        }
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
