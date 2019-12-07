# MovieViewer
MovieViewer is a movies app displaying box office and top rental DVDs using [The Movie Database API](https://developers.themoviedb.org/3). Made for CodePath University weeks 1 and 2.

## User Stories

The following **required** functionality is completed:
- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list. <br><br>

- [X] User can view movie details by tapping on a cell.
- [X] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [X] Customize the selection effect of the cell.

The following **optional** features are implemented:
- [X] User sees an error message when there's a networking error.
- [X] Movies are displayed using a CollectionView instead of a TableView.
- [X] User can search for a movie.
- [X] All images fade in as they are loading.
- [X] Customize the UI.<br><br>
- [X] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [X] Customize the navigation bar.

The following **additional** features are implemented:
- [X] User may switch between collection view or table view.
- [X] Auto layout on all pages except the Details page. Scroll view and auto layout beat me here!
- [X] User may switch between TableView and CollectionView via a TabBarController.
- [X] Auto layout on all pages except the Details page. Scroll view and auto layout beat me here!
- [X] User may scroll infinitely. (Table view only right now)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I'd like to get an idea of how to clean up my code. Right now it seems like there is a lot too it and it is a bit messy.
2. Trying to get both collection and table views to implement together while maintaining the tab bar was very difficult
   and I didn't quite get it down. I'd like to see if that could actually be done and how.

## Video Walkthrough 
NOTE: Walkthrough gif is currently out of date.
Here's a walkthrough of implemented user stories:

![Movie Viewer Walkthrough](movieViewerWalkthrough.gif)


GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes
tickets by Arthur Lacôte from the Noun Project
movie star by Studio Fibonacci from the Noun Project
Clapperboard by Studio Fibonacci from the Noun Project

Describe any challenges encountered while building the app.

## License

    Copyright 2016 Dustyn Buchanan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
