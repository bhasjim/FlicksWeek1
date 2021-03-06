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
    var endPoint: String!;
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else{
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! MovieCollectionCell
        cell.layer.borderColor = UIColor.clear.cgColor;
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            cell.highlightView?.alpha = 0.0
        })

        print("unhighlight")


    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! MovieCollectionCell

        cell.layer.borderColor = UIColor(red:1.0, green:0.49, blue:0.0, alpha:0.5).cgColor;
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 8 // optional
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            cell.highlightView?.alpha = 0.5
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell;
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String;
        
        cell.movieTitle.text = title;

        //making large and small requests
        let smallUrl = "https://image.tmdb.org/t/p/w45";
        let largeUrl = "https://image.tmdb.org/t/p/original";
        
        //if movie["poster_path" is nil, then skip everything in the curly braces
        if let posterPath = movie["poster_path"] as? String {
            let smallImageUrl = smallUrl + posterPath;
            let largeImageUrl = largeUrl + posterPath;

            
            let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl)! as URL)
            let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl)! as URL)
            

            cell.movieImage.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    cell.movieImage.alpha = 0.0
                    cell.movieImage.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        cell.movieImage.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        cell.movieImage.setImageWith(
                            largeImageRequest as URLRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                cell.movieImage.image = largeImage;
                                
                        },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                    })
            },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            });


            
        }
        
        
        
        return cell;
    }
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        // ... Create the URLRequest `myRequest` ...
        
        
        // Configure session so that completion handler is executed on main UI thread
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
       
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as? [NSDictionary];
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
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
 


        // Configure session so that completion handler is executed on main UI thread
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as? [NSDictionary];
                    self.collectionView.reloadData();
                    refreshControl.endRefreshing();
                }
            }
        }
        task.resume()
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
