//
//  ImageLoader.swift
//  getPictures (iOS)
//
//  Created by Richard Urunuela on 25/02/2022.
//

import Foundation
struct PhotoLoader {
    var urlSession = URLSession.shared
    var decoder = JSONDecoder()
    var page = 1
    let urlForLoadingImagesDescription: (String, Int) -> URL?  = { query, page in
        let urlString =  "https://api.unsplash.com/search/photos?" + "query=\(query)&page=\(page)"  +
        "&client_id=" +
        "a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4"
        return URL(string: urlString)
    }

    func loadImagesDecription(query: String, page: Int) async  -> (Result<SearchPhotosResponse, Error>) {
        guard let url = urlForLoadingImagesDescription(query, page) else {
            return Result .failure(NetworkError.badURL)

        }
        do {
        let (data, _) = try await urlSession.data(from: url)
       let resultat = try decoder.decode(SearchPhotosResponse.self, from: data)
            return Result .success(resultat)
        } catch {
                return Result .failure(error)
        }
    }
    func getImageData(urlString: String) async  -> (Result<Data, Error>) {
        guard let url = URL(string: urlString) else { return
            Result .failure(NetworkError.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return Result .success(data)
        } catch {
            return Result .failure(error)
        }
    }
}
