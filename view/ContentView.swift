//
//  ContentView.swift
//  getPictures
//
//  Created by Richard Urunuela on 26/02/2022.
//  To use with  native  keyboard  do not use : connect keyboard
//

import SwiftUI
import Combine
class RequestLoaderViewModel: ObservableObject {
    var searchPhotosResponse: SearchPhotosResponse?
    var query: String?
    var page = 1
    @Published  var showingAlert = false
    @Published var photoList = [Photo]()
    func flushPage() {
        print(" GET PAGE \(page)")
        page += 1
        if let query = self.query {
            getData(query: query)
        }
    }
    func getData(query: String) {
        self.query = query
        if page == 1 {
            photoList = [Photo]()
        }

        Task {
            let resultat  = await PhotoLoader().loadImagesDecription(query: query, page: self.page)
            switch resultat {
            case .failure :
                print(" ERROR ")
                DispatchQueue.main.async {
                    self.showingAlert = true
                }
            case .success(let response):
                self.searchPhotosResponse = response
                DispatchQueue.main.async {
                    self.photoList.append(contentsOf: response.results)
                }
                print(" SUCCESS ")
            }
        }
    }
}
struct ContentView: View {
    @ObservedObject var requestLoader: RequestLoaderViewModel = RequestLoaderViewModel()
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack {
                List( self.requestLoader.photoList) {  entry in
                    PhotoThumb(withURL: entry.urls.thumb, description: entry.description ?? "" ).id(entry.id).onAppear {
                        let pos = self.requestLoader.photoList.firstIndex(where: {photo in photo.id == entry.id})
                        if pos   == self.requestLoader.photoList.count - 1 {
                            self.requestLoader.flushPage()
                        }
                    }
                }.listStyle(.plain)
            }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { val in
                if self.searchText.count > 0 {
                    requestLoader.page = 1
                    requestLoader.getData(query: searchText)
                }
            }.navigationTitle("get Pictures ")
        }.searchable(text: $searchText, prompt: "Search  Images")
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Request error", isPresented: self.$requestLoader.showingAlert) {
                       Button("OK", role: .cancel) {
                           self.searchText = ""
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
