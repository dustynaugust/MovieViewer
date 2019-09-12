//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by ccsfcomputers on 1/19/16.
//  Copyright © 2016 Dustyn Buchanan. All rights reserved.


// FIX NETWORK ERROR FOR ALL
    // Update timing of network error.



import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorTableview: UIView!
    @IBOutlet weak var networkErrorLabel: UIView!
    
    var movies: [NSDictionary] = []
    var searchedForMovies: [NSDictionary]?

    var endpoint: String!
    var searchBar = UISearchBar()
    
    var isMoreDataLoading = false
    var pageNum = 1
    var indexPath = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"TableView", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem?.image = UIImage(named: "gridMarekPolakovic")
        
        //networkErrorLabel.isHidden = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search movie titles"
        navigationItem.titleView = searchBar
        
        self.networkErrorTableview.isHidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        getStuffFromNetwork()

        // Do any additional setup after loading the view.
    }
    
    private func createURL(endpoint: String, pageNumber: String) -> URL? {
        return URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(Keys.DB.apiKey)&page=\(pageNumber)")
    }
    
    func getStuffFromNetwork() {
        let pageNumString = String(self.pageNum)
        
        
        if let url = createURL(endpoint: Keys.DB.Endpoints.nowPlaying, pageNumber: pageNumString) {
            let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 4)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
            
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let task : URLSessionDataTask = session.dataTask(with: request,
                                                             completionHandler: { (dataOrNil, response, error) in
                                                                if let data = dataOrNil {
                                                                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                                                        // NSLog("response: \(responseDictionary)")
                                                                        
                                                                        MBProgressHUD.hide(for: self.view, animated: true)
                                                                        
                                                                        self.movies.append(contentsOf: responseDictionary["results"] as! [NSDictionary])
                                                                        self.searchedForMovies = self.movies
                                                                        self.tableView.reloadData()
                                                                        self.networkErrorTableview.isHidden = true
                                                                    }
                                                                } else {
                                                                    self.networkErrorTableview.isHidden = false
                                                                    MBProgressHUD.hide(for: self.view, animated: true)
                                                                    
                                                                    //self.tableView.reloadData()
                                                                    self.getStuffFromNetwork()
                                                                }
                                                                // Update flag
                                                                self.isMoreDataLoading = false
            });
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedForMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.selectionStyle = .none
        cell.accessoryType = .none
        let movie = searchedForMovies![indexPath.row]
//        let movie = movies![indexPath.row]

        // Adds words
        let title = movie[Keys.DB.Results.title] as! String
        let overview = movie[Keys.DB.Results.overview] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
       
        
        if let posterPath = movie[Keys.DB.Results.posterPath] as? String {
            let smallImageUrl = URL(string: Keys.DB.smallBaseURL + posterPath)
            let largeImageUrl = URL(string: Keys.DB.largeBaseURL + posterPath)
            // cell.posterView.setImageWithURL(posterUrl!)
            
            
            let smallImageRequest = URLRequest(url: smallImageUrl!)
            let largeImageRequest = URLRequest(url: largeImageUrl!)
            
            cell.posterView.setImageWith(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        cell.posterView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            cell.posterView.setImageWith(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    cell.posterView.image = largeImage;
                                    
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
            })
        }
        else {
            cell.posterView.image = nil
        }
        return cell
    }

    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        getStuffFromNetwork()
        refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        searchedForMovies = searchText.isEmpty ? movies : movies.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (movie[Keys.DB.Results.title] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchedForMovies = self.movies
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                self.pageNum+=1
                isMoreDataLoading = true
                
                // Code to load more results
                getStuffFromNetwork()
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == Keys.Segues.SegueToMoviesCollectionViewController ) {
            
        }
        else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = searchedForMovies![indexPath!.row]
        
            let detailTableViewController = segue.destination as! DetailTableViewController
            detailTableViewController.movie = movie
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
