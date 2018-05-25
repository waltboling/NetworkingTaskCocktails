//
//  CocktailTVC.swift
//  NetworkingTaskCocktails
//
//  Created by Jon Boling on 5/25/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class CocktailTVC: UITableViewController {
    var cocktails = Array<String>()
    
    func getCocktailData(urlString: String) {
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                self.fillCocktailTable(cocktailData: data!)
            })
        }
        task.resume()
    }
    
    func fillCocktailTable(cocktailData: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: cocktailData, options: []) as! Dictionary<String, AnyObject>
            if let drinks = json["drinks"] as?  [Dictionary<String, String>]{
                for i in drinks
                {
                    if let cocktailName = i["strDrink"] {
                        cocktails.append(cocktailName)
                    }
                }
            }
        } catch {
            print("Error fetching data")
        }
        print("In fill method: \(cocktails.count)")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCocktailData(urlString: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail")
        print("In view did load: \(cocktails.count)")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cocktailCell", for: indexPath)
        
        cell.textLabel?.text = cocktails[indexPath.row]

        return cell
    }
}
