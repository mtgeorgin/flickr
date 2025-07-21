//
//  FlickrPhotos.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 19/7/2025.
//

import Foundation

struct FlickrData: Decodable {
    let photos: Photos
    let stat: String

}

struct Photos: Decodable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}
