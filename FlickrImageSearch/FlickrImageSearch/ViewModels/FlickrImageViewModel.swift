//
//  FlickrImageViewModel.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 19/7/2025.
//

import Foundation
import Combine

class FlickrImageViewModel: ObservableObject {
    @Published var viewState: ViewState = .initial
    
    var flickrImages: [Photo] = []
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private let imagesPerPage = 30
    private let service: FlickrAPIService

    enum ViewState {
        case initial
        case loading
        case loaded([Photo])
        case error(Error)
    }

    // MARK: - Public Methods
    
    init(apiService: FlickrAPIService = .create()) {
        service = apiService
    }
    
    func searchFirstPage(_ searchText: String) {
        resetSearch()
        fetchImages(searchText)
    }
    
    func loadNextPage(_ searchText: String) {
        currentPage += 1
        fetchImages(searchText)
    }

    // MARK: - Private Methods
    
    private func resetSearch() {
        currentPage = 1
        flickrImages.removeAll()
        cancellables.removeAll()
    }

    private func fetchImages(_ searchText: String) {
        if flickrImages.isEmpty {
            self.viewState = .loading
        }
        
        service.searchImages(
            query: searchText,
            page: currentPage,
            perPage: imagesPerPage
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: handleCompletion,
            receiveValue: { [weak self] searchResult in
                Logger.debug("Received \(searchResult.photos.photo.count) images")
                    
                let newPhotos = self?.removeDuplicateFromFlickrAPI(searchResult.photos.photo)
                self?.flickrImages.append(contentsOf: newPhotos ?? [])
                self?.viewState = .loaded(self?.flickrImages ?? [])
            }
        )
        .store(in: &cancellables)

    }

    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            Logger.error("Failed to fetch images: \(error)")
            viewState = .error(error)
        case .finished:
            Logger.debug("Image fetch completed successfully")
        }
    }
    
    /// Flickr API returns duplicate of last element from previous page
    private func removeDuplicateFromFlickrAPI(_ newPhotos: [Photo]) -> [Photo] {
        guard let lastExistingPhoto = flickrImages.last,
            let firstNewPhoto = newPhotos.first, lastExistingPhoto.id == firstNewPhoto.id,
                  newPhotos.count > 1 else {
                return newPhotos
            }
            
        return Array(newPhotos.dropFirst())
    }

    private enum Logger {
        static func debug(_ message: String) {
            print("🔍 DEBUG: \(message)")
        }
        
        static func error(_ message: String) {
            print("❌ ERROR: \(message)")
        }
    }
}
