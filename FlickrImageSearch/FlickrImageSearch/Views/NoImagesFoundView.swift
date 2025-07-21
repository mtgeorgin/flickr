//
//  NoImagesFoundView.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 20/7/2025.
//

import SwiftUI

struct NoImagesFoundView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No images found")
                    .font(.headline)
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

#Preview {
    NoImagesFoundView()
}
