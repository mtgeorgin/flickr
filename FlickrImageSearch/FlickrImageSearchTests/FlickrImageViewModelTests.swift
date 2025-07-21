//
//  FlickrImageViewModelTests.swift
//  FlickrImageSearchTests
//
//  Created by Martin Georgin on 21/7/2025.
//

import XCTest
import Combine
@testable import FlickrImageSearch

final class FlickrImageViewModelTests: XCTestCase {
    var viewModel: FlickrImageViewModel!
    var mockAPIService: MockFlickrAPIService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockFlickrAPIService()
        viewModel = FlickrImageViewModel(apiService: mockAPIService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Search First Page Tests
    
    func testSearchFirstPage_WithValidSearchText_ShouldSetLoadingState() {
        // Given
        let searchText = "cats"
        let expectation = expectation(description: "Loading state should be set")
        
        // When
        viewModel.$viewState
            .dropFirst() // Skip initial state
            .sink { state in
                if case .loading = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchFirstPage(searchText)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchFirstPage_WithSuccessfulResponse_ShouldUpdateStateToLoaded() {
        // Given
        let searchText = "dogs"
        let mockPhotos = createMockPhotos(count: 3)
        let mockSearchResult = SearchResult(photos: PhotosResponse(photo: mockPhotos))
        mockAPIService.searchImagesResult = .success(mockSearchResult)
        
        let expectation = expectation(description: "Should update to loaded state")
        
        // When
        viewModel.$viewState
            .dropFirst() // Skip initial state
            .sink { state in
                if case .loaded(let photos) = state {
                    XCTAssertEqual(photos.count, 3)
                    XCTAssertEqual(photos.first?.id, "1")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchFirstPage(searchText)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchFirstPage_WithFailedResponse_ShouldUpdateStateToError() {
        // Given
        let searchText = "birds"
        let mockError = URLError(.notConnectedToInternet)
        mockAPIService.searchImagesResult = .failure(mockError)
        
        let expectation = expectation(description: "Should update to error state")
        
        // When
        viewModel.$viewState
            .dropFirst() // Skip initial state
            .sink { state in
                if case .error(let error) = state {
                    XCTAssertEqual(error as? URLError, mockError)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchFirstPage(searchText)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Load Next Page Tests
    
    func testLoadNextPage_WithExistingSearch_ShouldAppendNewPhotos() {
        // Given
        let searchText = "flowers"
        let firstPagePhotos = createMockPhotos(count: 2, startingId: 1)
        let secondPagePhotos = createMockPhotos(count: 2, startingId: 3)
        
        let firstPageResult = SearchResult(photos: PhotosResponse(photo: firstPagePhotos))
        let secondPageResult = SearchResult(photos: PhotosResponse(photo: secondPagePhotos))
        
        mockAPIService.searchImagesResults = [.success(firstPageResult), .success(secondPageResult)]
        
        let expectation = expectation(description: "Should load next page")
        var stateChanges = 0
        
        // When
        viewModel.$viewState
            .dropFirst()
            .sink { state in
                stateChanges += 1
                if case .loaded(let photos) = state, stateChanges == 2 {
                    XCTAssertEqual(photos.count, 4)
                    XCTAssertEqual(photos.first?.id, "1")
                    XCTAssertEqual(photos.last?.id, "4")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchFirstPage(searchText)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.loadNextPage(searchText)
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Helper Methods
    
    private func createMockPhotos(count: Int, startingId: Int = 1) -> [Photo] {
        return (startingId..<startingId + count).map { id in
            Photo(
                id: String(id),
                title: "Photo \(id)",
                farm: 1,
                server: "server",
                secret: "secret"
            )
        }
    }
}

// MARK: - Mock API Service

class MockFlickrAPIService: FlickrAPIService {
    var searchImagesCallCount = 0
    var searchImagesResult: Result<SearchResult, Error> = .success(SearchResult(photos: PhotosResponse(photo: [])))
    var searchImagesResults: [Result<SearchResult, Error>] = []
    private var currentResultIndex = 0
    
    func searchImages(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchResult, Error> {
        searchImagesCallCount += 1
        
        let result: Result<SearchResult, Error>
        
        if !searchImagesResults.isEmpty && currentResultIndex < searchImagesResults.count {
            result = searchImagesResults[currentResultIndex]
            currentResultIndex += 1
        } else {
            result = searchImagesResult
        }
        
        return result.publisher
            .delay(for: .milliseconds(50), scheduler: RunLoop.main) // Simulate network delay
            .eraseToAnyPublisher()
    }
    
    func create() -> MockFlickrAPIService {
        return MockFlickrAPIService()
    }
    
    init() {
        super.init()
    }
}

// MARK: - Mock Data Models

struct SearchResult {
    let photos: PhotosResponse
}

struct PhotosResponse {
    let photo: [Photo]
}

struct Photo: Identifiable, Equatable {
    let id: String
    let title: String
    let farm: Int
    let server: String
    let secret: String
}
