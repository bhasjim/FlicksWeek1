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
    
    var movie:NSDictionary!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let overviewText = movie["overview"] as! String;
        Overview.text = overviewText;
        
        let title = movie["title"] as! String;
        movieTitle.text = title;
        
        let baseUrl = "https://image.tmdb.org/t/p/w500/";
        let posterPath = movie["poster_path"] as! String;
        let imageUrl = NSURL(string:baseUrl + posterPath);
        
        posterImageView.setImageWith(imageUrl as! URL);

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
