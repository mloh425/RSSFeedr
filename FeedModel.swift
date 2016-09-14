//
//  FeedModel.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/13/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

class FeedModel: NSObject, NSXMLParserDelegate {
    
    let feedUrlString: String = "https://jalopnik.com/rss"
    var articles:[Article] = [Article]()
    
    //Parser variables
    var currentElement: String = ""
    var foundCharacters: String = ""
    var attributes:[NSObject: AnyObject]?
    var currentlyConstructingArticle: Article = Article()
    
    func getArticles(){
        //Initialize a new Parser
        let feedUrl:NSURL? = NSURL(string: feedUrlString) //initializer returns optional
        let feedParser:NSXMLParser? = NSXMLParser(contentsOfURL: feedUrl!)
        
        if let actualFeedParser = feedParser {
            //Download feed and parse out articles
            actualFeedParser.delegate = self
            actualFeedParser.parse()
        }
        
    }
    
    //item, title, link, description tags are ones we care about
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            self.foundCharacters = ""
        } else if elementName == "title" ||
            elementName == "link" ||
            elementName == "description" {
            self.currentElement = elementName
        }
//        if elementName == "item" ||
//           elementName == "title" ||
//           elementName == "link" ||
//           elementName == "description" {
//            self.currentElement = elementName
//            self.attributes = attributeDict
//        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement == "item" ||
            currentElement == "title" ||
            currentElement == "link" ||
            currentElement == "description" {
            self.foundCharacters += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            //Parsing of item is complete
            self.articles.append(self.currentlyConstructingArticle)
            //start new article
            self.currentlyConstructingArticle = Article()
            //self.foundCharacters = ""
        }
        else if elementName == "title" {
            //Parsing of title element is complete, save
                self.currentlyConstructingArticle.articleTitle = foundCharacters
                self.foundCharacters = ""
            //Reset found characters
        }
        else if elementName == "description" {
            self.currentlyConstructingArticle.articleDescription = foundCharacters
            //Extract image content and save to imageURL property of article object
            self.foundCharacters = ""
        }
        else if elementName == "link" {
            self.currentlyConstructingArticle.articleLink = foundCharacters
            self.foundCharacters = ""
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        //Notify VC that array of articles is ready
    }
    
}