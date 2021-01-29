//
//  Constants.swift
//  itunesApp
//
//  Created by Ignacio Segui on 24/01/2021.
//

import Foundation


public struct Constants {
    static var kSearchSongApiUrl = "https://itunes.apple.com/search?term=[data]&mediaType=music&limit=20"
    static var kSearchAlbumApiUrl = "https://itunes.apple.com/search?term=[data]&mediaType=music&limit=20"
    static var welcomeText = "WELCOME!"
    static var descriptionLabelText = "Type any artist, song or album"
    static var searchText = "Search"
    static var loading = "Loading..."
    static var errorSearchMessage = "You must enter a word to search."
    static var errorNoSongsFoundMessage = "No matches found."
    static var okString = "Ok"
    static var searchResults = "Search results"
    struct Constraits {
        static var kLeftInsetConstrait = 10.0
        static var kRightInsetConstrait = -10.0
        static var kTopInsetConstrait = 10.0
        static var kBottomInsetConstrait = -10.0
    }
}
