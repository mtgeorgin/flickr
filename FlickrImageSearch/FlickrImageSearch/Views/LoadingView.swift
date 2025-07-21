//
//  LoadingView.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 21/7/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Text("Searching images...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}
