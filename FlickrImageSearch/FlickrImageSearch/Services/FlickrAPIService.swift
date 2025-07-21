//
//  FlickrAPIService.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 19/7/2025.
//

import Foundation
import Combine

// MARK: - Configuration

struct FlickrServiceConfiguration {
    let baseURL: String
    let method: String
    let extras: String
    let timeoutInterval: TimeInterval
    
    static let `default` = FlickrServiceConfiguration(
        baseURL: "https://api.flickr.com/services/rest/",
        method: "flickr.photos.search",
        extras: "url_t",
        timeoutInterval: 5.0
    )
}

class FlickrAPIService {
    private let configuration: FlickrServiceConfiguration
    
    // MARK: - Public Methods

    static func create() -> FlickrAPIService {
        FlickrAPIService(configuration: .default)
    }
    
    func searchImages(query: String, page: Int, perPage: Int) -> AnyPublisher<FlickrData, Error> {
        let request = configureService(query: query, page: page, perPage: perPage, config: configuration)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: FlickrData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods
    
    init(configuration: FlickrServiceConfiguration = .default) {
        self.configuration = configuration
    }

    private func configureService(query: String, page: Int, perPage: Int, config: FlickrServiceConfiguration) -> URLRequest {
        
        ///Storing the API key in the plist isn't secure, better to use something like CloudKit
        let apiKey = Bundle.main.infoDictionary?["FlickrAPIKey"] as? String ?? ""
        
        var components = URLComponents(string: config.baseURL)!

        components.queryItems = [
            URLQueryItem(name: "method", value: config.method),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "text", value: query),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "extras", value: config.extras)
        ]
        
        return URLRequest(url: components.url!, timeoutInterval: config.timeoutInterval)
    }
}
