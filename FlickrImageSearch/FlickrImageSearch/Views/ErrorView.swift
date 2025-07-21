//
//  ErrorView.swift
//  FlickrImageSearch
//
//  Created by Martin Georgin on 21/7/2025.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text("Something went wrong")
                .font(.title2)
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ErrorView(error: NSError(domain: "error", code: 0, userInfo: nil))
}
