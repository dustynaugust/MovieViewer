//
//  DetailTableViewController.swift
//  MovieViewer
//
//  Created by Dustyn August on 1/25/16.
//  Copyright © 2016 ccsfcomputers. All rights reserved.
//

// Do the same thing Charlie does but instead use a UIImage use a UIView with a clear background. then have the Image as the background.

import UIKit

class MVDetailViewController: UIViewController {
    
    @IBOutlet weak var falsePosterView: UIView!
    @IBOutlet weak var posterDetailTableImageView: UIImageView!
    @IBOutlet weak var titleDetailLabel: UILabel!
    @IBOutlet weak var overviewDetailLabel: UILabel!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as? String
        titleDetailLabel.text = title
        titleDetailLabel.sizeToFit()
        
        let overview = movie["overview"] as?String
        overviewDetailLabel.text = overview
        overviewDetailLabel.sizeToFit()
        
        let width = detailScrollView.frame.size.width
        let height = infoView.frame.origin.y + overviewDetailLabel.frame.size.height + overviewDetailLabel.frame.size.height + overviewDetailLabel.frame.size.height
        detailScrollView.contentSize = CGSize(width: width, height: height)
        
        infoView.layer.cornerRadius = 2.0
        infoView.clipsToBounds = true
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL(string: baseUrl + posterPath)
            posterDetailTableImageView.setImageWith(posterUrl!)
        } else {
            posterDetailTableImageView.image = nil
        }
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
