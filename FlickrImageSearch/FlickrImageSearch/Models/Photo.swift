//
//  FlickrImage.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 19/7/2025.
//

import Foundation

struct Photo: Decodable, Identifiable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let thumbnailURL: String
    
    ///compute image URL from decoded json data
    var url: URL {
        get{
            URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")!
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case farm
        case title
        case thumbnailURL = "url_t"
    }
}

/*
 Sample Flickr image data

 {
    "id": "54663688726",
    "owner": "196777790@N03",
    "secret": "da37289807",
    "server": "65535",
    "farm": 66,
    "title": "At the vet",
    "url_t": "https:\/\/live.staticflickr.com\/65535\/54663777578_69c4c85976_t.jpg"
    "ispublic": 1,
    "isfriend": 0,
    "isfamily": 0
}
 
 http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
 http://farm66.static.flickr.com/65535/54663688726_da37289807.jpg
 */
