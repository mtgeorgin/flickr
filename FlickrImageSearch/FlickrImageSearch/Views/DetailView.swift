//
//  DetailView.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 19/7/2025.
//

import SwiftUI

struct DetailView: View {
    let item: Photo

    var body: some View {
        VStack {
            AsyncImage(url: item.url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            Text(item.title)
        }
    }
}

#Preview {
    DetailView(item: Photo(
        id: "54663688726",
        secret: "da37289807",
        server: "65535",
        farm: 66,
        title: "String",
        thumbnailURL: "https://live.staticflickr.com/65535/54663923924_b82b1d4616_t.jpg"
)
    )
}
