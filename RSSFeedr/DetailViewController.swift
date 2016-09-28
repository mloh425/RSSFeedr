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
        let titleIcon:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        titleIcon.image = UIImage(named: "JalopnikIcon")
        self.navigationItem.titleView = titleIcon

        if let actualArticle = self.articleToDisplay {
            //Create NSURL for article URL
            print(actualArticle.articleLink)
            let modifiedURL = actualArticle.articleLink.replacingOccurrences(of: "http", with: "https", options: String.CompareOptions.literal, range: nil)
            let url: URL? = URL(string: modifiedURL)
            //Create NSURL Request for NSURL
            if let actualUrl = url {
                let urlRequest: URLRequest = URLRequest(url: actualUrl)
                self.webView.loadRequest(urlRequest)
            }
            //Pass request into webview to load page
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
