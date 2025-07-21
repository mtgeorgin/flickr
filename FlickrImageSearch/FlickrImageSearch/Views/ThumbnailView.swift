//
//  ThumbnailView.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 19/7/2025.
//

import SwiftUI

struct ThumbnailView: View {
    let size: Double
    let item: Photo

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string:item.thumbnailURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size, height: size)
        }
    }
}

#Preview {
    ThumbnailView(size: 50, item: Photo(
        id: "54663688726",
        secret: "da37289807",
        server: "65535",
        farm: 66,
        title: "String",
        thumbnailURL: "https://live.staticflickr.com/65535/54663923924_b82b1d4616_t.jpg"
    )
    )
}
