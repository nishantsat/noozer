//
//  ViewController.swift
//  Noozer
//
//  Created by Nishant S on 6/1/17.
//  Copyright © 2017 Hypertenuse. All rights reserved.
//

import UIKit

extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

class ViewController: UIViewController, XMLParserDelegate {
    
    var itemFlag = false
    var descFlag = false
    var newsData = ""
    
    @IBOutlet var news: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let parser = getXmlParser()!
        parser.delegate = self
        parser.parse()
        news.text = newsData
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getXmlParser() -> XMLParser? {
        let myURLString = "http://zeenews.india.com/rss/india-national-news.xml"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return nil
        }
        
        return XMLParser(contentsOf: myURL)
    }
    func getNews() -> String? {
        let myURLString = "http://zeenews.india.com/rss/india-national-news.xml"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return nil
        }
        
        var myHTMLString: String?
        do {
            myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            print("HTML : \(myHTMLString)")
        } catch let error {
            print("Error: \(error)")
        }
        return myHTMLString
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            itemFlag = true
        }
        else if elementName == "description" {
            descFlag = true
            newsData += "\n\n"
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            itemFlag = false
        }
        else if elementName == "description" {
            descFlag = false
        }

    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if itemFlag == true && descFlag == true {
            newsData += string.condensedWhitespace
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    }

}

