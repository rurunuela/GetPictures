//
//  PhotoThumb.swift
//  getPictures
//
//  Created by Richard Urunuela on 27/02/2022.
//

import SwiftUI
import Combine
// create protocol
enum NetworkError: Error {
    case badURL
}
class ImageLoaderViewModel: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var urlString = ""
    var data: Data = Data() {
        didSet {
            didChange.send(data)
        }
    }
   func getImage() {
        Task {
            let result = await PhotoLoader().getImageData(urlString: self.urlString)
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.data = data
                }
            case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    init(urlString: String) {
        self.urlString = urlString
    }

}

struct PhotoThumb: View {
        @ObservedObject var imageLoader: ImageLoaderViewModel
        @State var image: UIImage = UIImage()
        var description: String
        init(withURL url: String, description: String) {
               imageLoader = ImageLoaderViewModel(urlString: url)
               self.description = description

           }
           var body: some View {
               VStack {
                   ZStack {
                   Image(uiImage: image)
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .onReceive(imageLoader.didChange) { data in
                       self.image = UIImage(data: data) ?? UIImage()
                         print("CREATE \(self.image.size)")
                       }.onAppear {
                           self.imageLoader.getImage()
                       }
                       if self.image.size.height == 0 {
                           ProgressView()
                       }
                   }
                   VStack(alignment: .leading, spacing: 5) {
                       Spacer()
                       Text(self.description).foregroundColor(.black).background(.white)

                   }.padding(8)
               }
           }
    }

struct PhotoThumb_Previews: PreviewProvider {
    static var previews: some View {
        PhotoThumb(withURL: "https://test", description: "Description")
    }
}
