//
//  iTunesServiceModel.swift
//  itunesApp
//
//  Created by Ignacio Segui on 26/01/2021.
//

import Foundation

public struct iTunesServiceModelGeneral: Codable {
    
    let resultCount: Int?
    let results: [iTunesServiceModel]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        results = try values.decodeIfPresent([iTunesServiceModel].self, forKey: .results)
    }
}


public struct iTunesServiceModel: Codable {
    
    let wrapperType: String?
    let kind: String?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artworkUrl100: String?
    let previewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType = "wrapperType"
        case kind = "kind"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case trackName = "trackName"
        case artworkUrl100 = "artworkUrl100"
        case previewUrl = "previewUrl"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        wrapperType = try values.decodeIfPresent(String.self, forKey: .wrapperType)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
        collectionName = try values.decodeIfPresent(String.self, forKey: .collectionName)
        trackName = try values.decodeIfPresent(String.self, forKey: .trackName)
        artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100)
        previewUrl = try values.decodeIfPresent(String.self, forKey: .previewUrl)
    }
}
