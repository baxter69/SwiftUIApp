//
//  File.swift
//  SwiftUIApp
//
//  Created by user on 19.02.2025.
//

import SwiftUI
import SafariServices

struct NewsDetailView: View {
    @StateObject private var viewModel: ViewModel
    @State private var showSafariView = false

    init(news: News) {
        _viewModel = StateObject(wrappedValue: ViewModel(news: news))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.news.title ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }

                Text(viewModel.news.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: false)
                
                HStack {
                    Text(viewModel.news.getDisplayDate())
                        .font(.footnote)
                        .foregroundColor(.mint)
                    Spacer()
                    if !viewModel.news.getAuthorSource().isEmpty {
                        Text(viewModel.news.getAuthorSource())
                            .font(.system(size: 12))
                            .foregroundStyle(.mint)
                    }
                }
                
                if let newsURL = viewModel.news.getURL() {
                    Button(action: {
                        showSafariView = true
                    }) {
                        Text("Читать полностью")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showSafariView) {
                        SafariView(url: newsURL)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(viewModel.news.title ?? "Новость")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Встроенный SafariView
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

