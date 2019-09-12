//
//  Keys.swift
//  MovieViewer
//
//  Created by Dustyn August on 9/11/19.
//  Copyright © 2019 ccsfcomputers. All rights reserved.
//

import Foundation

struct Keys {
    struct DB {
        static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        static let smallBaseURL = "http://image.tmdb.org/t/p/w45"
        static let largeBaseURL = "http://image.tmdb.org/t/p/original"

        struct Results {
            static let title = "title"
            static let overview = "overview"
            static let posterPath = "poster_path"
        }
        
        struct Endpoints {
            static let nowPlaying = "now_playing"
            static let topRated = "top_rated"
        }
        
    }
    
    struct Segues {
        static let SegueToDetailsViewController = "SegueToDetailsViewController"
    }
    struct StoryboardIDs {
        static let MVNavigationController = "MVNavigationController"
    }
}
