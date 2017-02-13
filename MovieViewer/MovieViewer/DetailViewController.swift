//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Nick Hasjim on 2/7/17.
//  Copyright © 2017 Nick Hasjim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var Overview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var movie:NSDictionary!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black;

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height); //making it so we can scroll down to the bottom
        
        let overviewText = movie["overview"] as! String;
        Overview.text = overviewText;
        Overview.sizeToFit();
        
        let title = movie["title"] as! String;
        movieTitle.text = title;
        
        //making large and small requests
        let smallUrl = "https://image.tmdb.org/t/p/w45";
        let largeUrl = "https://image.tmdb.org/t/p/original";
        
        //if movie["poster_path" is nil, then skip everything in the curly braces
        if let posterPath = movie["poster_path"] as? String {
            let smallImageUrl = smallUrl + posterPath;
            let largeImageUrl = largeUrl + posterPath;
            
            
            let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl)! as URL)
            let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl)! as URL)
            
            
            self.posterImageView.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.posterImageView.setImageWith(
                            largeImageRequest as URLRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.posterImageView.image = largeImage;
                                
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
