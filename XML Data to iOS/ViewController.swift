//
//  ViewController.swift
//  XML Data to iOS
//
//  Created by Ayush Singh on 26/03/22.
//

import UIKit

var url = String()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    private var myTableView: UITableView!
    
    
    
    let recordKey = "ListOfItems"
    let dictionaryKeys = Set<String>(["StationId","StationName","Logo"])
    
    
    
    var results: [[String: String]]?
    
    var currentDictionary: [String: String]?
    var currentValue: String?
    
    var StationName = [String]()
    var StationId = [String]()
    var Logo = [String]()
    
    var activityView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.isPrefetchingEnabled = true
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.view.addSubview(myTableView)
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    func showActivityIndicatory() {
        
       activityView.center = self.view.center
       self.view.addSubview(activityView)
       activityView.startAnimating()
   }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StationId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(StationName[indexPath.row])"
        
        
//        let url = URL(string: Logo[indexPath.row])
//        let data = try? Data(contentsOf: url!) 
//        cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    
    
}

extension ViewController: XMLParserDelegate {
    
    func loadData() {
        
        showActivityIndicatory()
        
        if let url = URL(string: url) {
            let request=URLRequest(url: url)
            
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("dataTaskWithRequest error: \(error)")
                    return
                }
                guard let data = data else {
                    print("dataTaskWithRequest data is nil")
                    return
                }
                
                
                
                let parser = XMLParser(data: data)
                parser.delegate = self
                if parser.parse() {
                    
                    
                    
                    var set = Set<String>()
                    let arraySet: [[String : String]] = self.results!.compactMap {
                        guard let name = $0["Logo"] else {return nil }
                        return set.insert(name).inserted ? $0 : nil
                    }
                    
                    self.Logo = arraySet.compactMap { $0["Logo"] }
                    self.StationName = arraySet.compactMap { $0["StationName"] }
                    self.StationId = arraySet.compactMap { $0["StationId"] }
                    
                    self.results = arraySet
                    
                    
                    print(self.results!)
                    
                }
                
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.activityView.removeFromSuperview()
                    self.myTableView.reloadData()
                    
                }
                
            }
            task.resume()
        }
    }
    
    
    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }
    
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            results!.append(currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary![elementName] = currentValue
            results!.append(currentDictionary!)
            
            currentValue = nil
        }
    }
    
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        
        currentValue = nil
        currentDictionary = nil
        results = nil
    }
    
    
}

struct Item {
    var StationId: String
    var StationName: String
    var Logo: String
}


