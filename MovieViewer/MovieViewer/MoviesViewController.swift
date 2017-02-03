//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Nick Hasjim on 1/31/17.
//  Copyright © 2017 Nick Hasjim. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var TableView: UITableView!
    var movies: [NSDictionary]?;
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell;
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String;
        let overview = movie["overview"] as! String;
        let baseUrl = "https://image.tmdb.org/t/p/w500/";
        let posterPath = movie["poster_path"] as! String;
        
        let imageUrl = NSURL(string:baseUrl + posterPath);
        
        
        cell.titleLabel.text = title;
        cell.overviewLabel.text = overview;
        cell.movieImage.setImageWith(imageUrl as! URL);
        return cell;
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else{
            return 0;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self;
        TableView.delegate = self;

        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as! [NSDictionary];
                    self.TableView.reloadData();
                }
            }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
