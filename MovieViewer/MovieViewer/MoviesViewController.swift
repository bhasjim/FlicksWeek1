//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Nick Hasjim on 1/31/17.
//  Copyright © 2017 Nick Hasjim. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [NSDictionary]?;
    let refreshControl = UIRefreshControl()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else{
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell;
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String;
        let overview = movie["overview"] as! String;
        let baseUrl = "https://image.tmdb.org/t/p/w500/";
        let posterPath = movie["poster_path"] as! String;
        
        let imageUrl = NSURL(string:baseUrl + posterPath);
        
        
        cell.movieTitle.text = title;
        cell.movieImage.setImageWith(imageUrl as! URL);
        return cell;
    }
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        // ... Create the URLRequest `myRequest` ...
        
        
        // Configure session so that completion handler is executed on main UI thread
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
       
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as! [NSDictionary];
                    self.collectionView.reloadData();
                    refreshControl.endRefreshing();
                }
            }
        }
        task.resume()
        //Do any additional setup after loading the view.
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        refreshControlAction(refreshControl);
        refreshControl.addTarget(self, action: "refreshControlAction:", for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.shared.statusBarStyle = .lightContent;
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell);
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController;
        detailViewController.movie = movie;
        print("prepare segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
