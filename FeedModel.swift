//
//  FeedModel.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/13/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

protocol FeedModelDelegate {
    //Any FeedModelDelegate must implement this method
    //FeedModel will call this when article array is ready
    func articlesReady()
}

class FeedModel: NSObject, NSXMLParserDelegate {
    
    let feedUrlString: String = "https://jalopnik.com/rss"
    var articles: [Article] = [Article]()
    var delegate: FeedModelDelegate?
    var feedParser:FeedParser = FeedParser()
    
    func getArticles(){
        //Create URL
        let feedUrl:NSURL? = NSURL(string: feedUrlString) //initializer returns optional
        
        //Listen to notification center
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(FeedModel.parserFinished), name: "feedParserFinished", object: self.feedParser)
        
        //Kick off feed helper to parse NSURL
        self.feedParser.startParsing(feedUrl!)
    }
    
    func parserFinished() {
        //TODO: Assign parsers list of articles to self.articles
        self.articles = self.feedParser.articles
        //Notify VC that array of articles is ready
        //Check if there is an object assigned as the delegate, if so called articlesReady method on delegate
        if let actualDelegate = self.delegate {
            actualDelegate.articlesReady()
        }
    }
}

