//
//  FeedParser.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/13/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    
    //Article Cache to prevent duplicate articles
    static var articleCache = [String: Article]()
    
    //Parsing Variables
    var currentElement: String = ""
    var foundCharacters: String = ""
    var attributes: [NSObject: AnyObject]?
    var currentlyConstructingArticle: Article = Article()
    var articles: [Article] = [Article]()
    
    override init() {
        super.init()
    }
    
    func startParsing(feedUrl: URL) {
        let feedParser:XMLParser? = XMLParser(contentsOf: feedUrl)
        if let actualFeedParser = feedParser {
            //Download feed and parse out articles
            actualFeedParser.delegate = self
            actualFeedParser.parse()
        }
    }
    
    //item, title, link, description tags are ones we care about
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
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
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "item" ||
            currentElement == "title" ||
            currentElement == "link" ||
            currentElement == "description" {
            self.foundCharacters += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            //Parsing of item is complete if article does not exist already, append it
            if FeedParser.articleCache[currentlyConstructingArticle.articleTitle] == nil {
                FeedParser.articleCache[currentlyConstructingArticle.articleTitle] = currentlyConstructingArticle
                self.articles.append(self.currentlyConstructingArticle)
                self.currentlyConstructingArticle = Article()
            }
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
            if let startRange = foundCharacters.range(of: "http", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) {
                if let endRange = foundCharacters.range(of: ".jpg", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) {
                    let imageLink = foundCharacters.substring(with: startRange.lowerBound..<endRange.upperBound)
                    self.currentlyConstructingArticle.articleImage = imageLink
                } else if let endRange = foundCharacters.range(of: ".png", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) {
                    let imageLink = foundCharacters.substring(with: startRange.lowerBound..<endRange.upperBound)
                    self.currentlyConstructingArticle.articleImage = imageLink
                } else if let endRange = foundCharacters.range(of: ".gif", options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) {
                    let imageLink = foundCharacters.substring(with: startRange.lowerBound..<endRange.upperBound)
                    self.currentlyConstructingArticle.articleImage = imageLink
                } else {
                    self.currentlyConstructingArticle.articleImage = "http://img.gawkerassets.com/img/1961cyhh037n5png/original.png"
                }
            }
            //            //Find Image Link by splitting description by quotes into array
            //
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
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //Use notification center to notify feedmodel
        let notificationCenter = NotificationCenter.default
        //specify self because observer is listening to an instance of this object specifically
        notificationCenter.post(name: NSNotification.Name(rawValue: "feedParserFinished"), object: self)
    }
}
