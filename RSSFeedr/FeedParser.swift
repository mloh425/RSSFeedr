//
//  FeedParser.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/13/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

class FeedParser: NSObject, NSXMLParserDelegate {
    //Parse Variable
    var currentElement: String = ""
    var foundCharacters: String = ""
    var attributes: [NSObject: AnyObject]?
    var currentlyConstructingArticle: Article = Article()
    var articles: [Article] = [Article]()
    
    override init() {
        super.init()
    }
    
    func startParsing(feedUrl: NSURL) {
        let feedParser:NSXMLParser? = NSXMLParser(contentsOfURL: feedUrl)
        if let actualFeedParser = feedParser {
            //Download feed and parse out articles
            actualFeedParser.delegate = self
            actualFeedParser.parse()
        }
    }
    
    //item, title, link, description tags are ones we care about
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            //Cleared characters because was picking up random characters
            //Also since Description is the last element being checked on, this clears all the characters from Description tag
            self.foundCharacters = ""
        } else if elementName == "title" ||
            elementName == "link" ||
            elementName == "description" {
            self.currentElement = elementName
            //self.attributes = attributeDict
        }
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
            //Assume that the link exists
            //Use range to extract image content
            if let startRange = foundCharacters.rangeOfString("http", options:NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                if let endRange = foundCharacters.rangeOfString(".jpg", options:NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    let imageLink = foundCharacters.substringWithRange(startRange.startIndex..<endRange.endIndex)
                    self.currentlyConstructingArticle.articleImage = imageLink
                } else if let endRange = foundCharacters.rangeOfString(".png", options:NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    let imageLink = foundCharacters.substringWithRange(startRange.startIndex..<endRange.endIndex)
                    self.currentlyConstructingArticle.articleImage = imageLink
                    
                } else if let endRange = foundCharacters.rangeOfString(".gif", options:NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    let imageLink = foundCharacters.substringWithRange(startRange.startIndex..<endRange.endIndex)
                    self.currentlyConstructingArticle.articleImage = imageLink
                }
            }
            //            //Find Image Link by splitting description by "'s
            //
            //            //This seems faster/more efficient in loading pictures than splitting the string?
            //            var descriptionSplitArray = foundCharacters.characters.split{$0 == "\""}.map(String.init)
            //            if descriptionSplitArray.count > 1 {
            //                let imageLink: String = descriptionSplitArray[1]
            //                self.currentlyConstructingArticle.articleImage = imageLink
            //            }
            //            self.foundCharacters = ""
            
        }
        else if elementName == "link" {
            self.currentlyConstructingArticle.articleLink = foundCharacters
            self.foundCharacters = ""
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        //Use notification center to notify feedmodel
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("feedParserFinished", object: self) //specify self because observer is listening to this object specifically
    }
}