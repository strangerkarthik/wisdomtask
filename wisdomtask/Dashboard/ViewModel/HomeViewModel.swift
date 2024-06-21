//
//  HomeViewModel.swift
//  wisdomtask
//
//  Created by JAISHIVA SN on 22/06/24.
//

import Foundation

class HomeViewModel {
    
    var getphotodatails:[photodetails] = []
    var photoList:[Photos] = []
    var currentPage = 1
    var isLoading = false
    var totalPages = 5
    var json: photodetails?
    
    func fetchphotos(page: Int, completion: @escaping() -> Void) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=20") else {
            print("Invalid URL")
            completion()
            return
        }
        isLoading = true
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isLoading = false 
            if let error = error {
                completion()
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                completion()
                return
            }
            do {
                let content = try JSONDecoder().decode([photodetails].self, from: data)
                self.getphotodatails += content
                print("is working",self.getphotodatails.count)
            
                completion()
            } catch {
                completion()
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}
