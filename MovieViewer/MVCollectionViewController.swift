//
//  MoviesCollectionViewController.swift
//  MovieViewer
//
//  Created by Dustyn August on 1/22/16.
//  Copyright © 2016 ccsfcomputers. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MVCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkErrorCollectionView: UIView!
    
    var movies: [NSDictionary] = []
    var searchedForMovies: [NSDictionary]?
    var endpoint: String!
    
    var isMoreDataLoading = false
    
    var searchBar = UISearchBar()
    var pageNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView.dataSource = self
        collectionView.backgroundView?.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search movie titles"
        navigationItem.titleView = searchBar
        
        self.networkErrorCollectionView.isHidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MVCollectionViewController.refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        getStuffFromNetwork()
        // Do any additional setup after loading the view.
    }
    private func createURL(endpoint: String, pageNumber: String) -> URL? {
        return URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(Keys.apiKey)&page=\(pageNumber)")
    }
    
    // Get stuff from network.
    func getStuffFromNetwork() {
        
        if let url = createURL(endpoint: endpoint, pageNumber: String(pageNum)) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 4)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main
            )
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let task: URLSessionDataTask = session.dataTask(with: request,
                                                            completionHandler: { (dataOrNil, _, _) in
                                                                if let data = dataOrNil {
                                                                    if let responseDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? NSDictionary {
                                                                        // NSLog("response: \(responseDictionary)")
                                                                        
                                                                        MBProgressHUD.hide(for: self.view, animated: true)
                                                                        
                                                                        self.movies.append(contentsOf: responseDictionary["results"] as? [NSDictionary] ?? [NSDictionary]())
                                                                        self.searchedForMovies = self.movies
                                                                        self.collectionView.reloadData()
                                                                        self.networkErrorCollectionView.isHidden = true
                                                                    }
                                                                } else {
                                                                    self.networkErrorCollectionView.isHidden = false
                                                                    self.collectionView.reloadData()
                                                                    
                                                                    MBProgressHUD.hide(for: self.view, animated: true)
                                                                    self.getStuffFromNetwork()
                                                                    // Note because of this call the MBProgressHUD freaks out unti the wifi is restored.
                                                                }
                                                                // Update flag
                                                                self.isMoreDataLoading = false
            })
            task.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get number of movies otherwise return 0.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedForMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
            // THIS IS VIEW STUFF
            cell.contentView.layer.cornerRadius = 2.0
            
            // Below adds movie posters to view
            let movie = searchedForMovies![indexPath.row]
            
            if let posterPath = movie[Resources.Results.posterPath] as? String {
                // Different url for smal & large images.
                let smallImageUrl = URL(string: Keys.smallBaseURL + posterPath)
                let largeImageUrl = URL(string: Keys.largeBaseURL + posterPath)
                
                // Below loads and sets the small then gets the large image.
                let smallImageRequest = URLRequest(url: smallImageUrl!)
                let largeImageRequest = URLRequest(url: largeImageUrl!)
                
                cell.posterCollectionView.setImageWith(
                    smallImageRequest,
                    placeholderImage: nil,
                    success: { (_, _, smallImage) -> Void in
                        
                        // smallImageResponse will be nil if the smallImage is already available
                        // in cache (might want to do something smarter in that case).
                        cell.posterCollectionView.alpha = 0.0
                        cell.posterCollectionView.image = smallImage
                        
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            
                            cell.posterCollectionView.alpha = 1.0
                            
                        }, completion: { (_) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            cell.posterCollectionView.setImageWith(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (_, _, largeImage) -> Void in
                                    
                                    cell.posterCollectionView.image = largeImage
                                    
                            },
                                failure: { (_, _, _) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                        })
                },
                    failure: { (_, _, _) -> Void in
                        // do something for the failure condition
                        // possibly try to get the large image
                })
            } else {
                cell.posterCollectionView.image = nil
            }
            return cell
        
        
        
    }
    
    // Refresh and so clean, clean.
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.collectionView.reloadData()
        getStuffFromNetwork()
        refreshControl.endRefreshing()
    }
    
    // Since CollectionView is about to appear set the CollectionViewDisplayed bool to true.
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "CollectionViewDisplayed")
        userDefaults.synchronize()
        print("Collection view is displayed: \(userDefaults.bool(forKey: "CollectionViewDisplayed"))")
        print("")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        searchedForMovies = searchText.isEmpty ? movies : movies.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            guard let movies = movie[Resources.Results.title] as? String else {
                return false
            }
            let range = movies.range(of: searchText, options: .caseInsensitive)
            return range != nil
        })
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchedForMovies = self.movies
        self.collectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("flag for collection scrollViewDidScroll")
        if !isMoreDataLoading {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging {
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
        
        if segue.identifier == Resources.Segues.SegueToDetailsViewController  {
            guard let cell = sender as? UICollectionViewCell else {
                return
            }
            let indexPath = collectionView.indexPath(for: cell)
            let movie = searchedForMovies![indexPath!.row]
            
            guard let detailTableViewController = segue.destination as? MVDetailViewController else {
                return
            }
            
            detailTableViewController.movie = movie
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
