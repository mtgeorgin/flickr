//
//  InitialView.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 21/7/2025.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("Welcome to Flickr Image Search")
                    .font(.title2)
                    .multilineTextAlignment(.center)
            Text("Enter a search term to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    InitialView()
}
