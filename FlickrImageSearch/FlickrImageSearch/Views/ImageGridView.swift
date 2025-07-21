//
//  ContentView.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 19/7/2025.
//

import SwiftUI

struct ImageGridView: View {
    @ObservedObject var imagesViewModel = FlickrImageViewModel()

    @State var searchText = ""
    @State var isTextInvalid: Bool = false
    @State var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    private static let initialColumns = 3
    
    private var searchHeader: some View {
        HStack {
            TextField("Enter image search term", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("Search", action: {
                if isTextValid(searchText) {
                    imagesViewModel.searchFirstPage(searchText)
                } else {
                    isTextInvalid = true
                }
            })
            .alert("Please enter at least two valid characters.", isPresented: $isTextInvalid) {
                        Button("OK", role: .cancel) { }
                    }
            .buttonStyle(.bordered)
            .padding()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchHeader
                switch imagesViewModel.viewState {
                    case .initial:
                        InitialView()
                    case .loading:
                        LoadingView()
                    case .error(let error):
                        ErrorView(error: error)
                    case .loaded(let photos):
                        if photos.isEmpty {
                            NoImagesFoundView()
                        } else {
                            ScrollView {
                                LazyVGrid(columns: gridColumns) {
                                    ForEach(photos) { item in
                                        GeometryReader { geo in
                                            NavigationLink(destination: DetailView(item: item)) {
                                                ThumbnailView(size: geo.size.width, item: item)
                                            }
                                        }
                                        .cornerRadius(8.0)
                                        .aspectRatio(1, contentMode: .fit)
                                        .onAppear {
                                            loadMoreImagesIfNeeded(item.id)
                                        }
                                    }
                                }
                                .padding()
                                ProgressView()
                        }
                    }
                }
            }
            .navigationBarTitle("Flickr Images Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func loadMoreImagesIfNeeded(_ itemId: String) {
        if itemId == imagesViewModel.flickrImages.last?.id {
            imagesViewModel.loadNextPage(searchText)
        }
    }
    
    func isTextValid(_ text: String) -> Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedText.count >= 2
    }
}

#Preview {
    ImageGridView()
}
