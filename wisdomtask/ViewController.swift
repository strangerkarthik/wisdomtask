//
//  ViewController.swift
//  wisdomtask
//
//  Created by JAISHIVA SN on 21/06/24.
//

import UIKit
import Foundation
 
class ViewController: UIViewController {
    
    @IBOutlet weak var photocollectiontable: UITableView!
    
    var getphotodatails:[photodetails] = []
    var currentPage = 1
    var isLoading = false
    var totalPages = 5
    var json: photodetails?
    
    override func viewDidLoad() {
       super.viewDidLoad()
       tablesetup()
       fetchphotos(page: currentPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("receive memory warning")
    }

    func tablesetup() {
        photocollectiontable.delegate = self
        photocollectiontable.dataSource = self
        photocollectiontable.refreshControl = UIRefreshControl()
        photocollectiontable.refreshControl?.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
    }
    
    @objc func refreshPhotos() {
        currentPage = 1
        getphotodatails.removeAll()
        fetchphotos(page: currentPage)
    }
    
    func fetchphotos(page: Int) {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=20") else {
            print("Invalid URL")
            return
        }
        isLoading = true
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.photocollectiontable.refreshControl?.endRefreshing()
            }
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let content = try JSONDecoder().decode([photodetails].self, from: data)
                self.getphotodatails.append(contentsOf: content)
                DispatchQueue.main.async {
                    self.photocollectiontable.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getphotodatails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photocollectiontable.dequeueReusableCell(withIdentifier: "photocell", for: indexPath) as! FetchTableViewCell
//        let photoindex = getphotodatails[indexPath.row]
//        cell.config(photo: photoindex)
//        cell.checkbox.tag = indexPath.row
//        cell.checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .valueChanged)
//
//        if indexPath.row == getphotodatails.count - 1 && !isLoading {
//            currentPage += 1
//            fetchphotos(page: currentPage)
//        }
        
        return cell
    }
    
    @objc func checkboxTapped(_ sender: UISwitch) {
           let photo = getphotodatails[sender.tag]
           let message = photo.url
           let alert = UIAlertController(title: "Photo URL", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == getphotodatails.count - 1 { // Last cell
            if currentPage < totalPages {
                currentPage += 1
                fetchphotos(page: currentPage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let photo = getphotodatails[indexPath.row]
//        if let cell = photocollectiontable.cellForRow(at: indexPath) as? FetchTableViewCell, cell.checkbox.isOn {
//            let alert = UIAlertController(title: "Description", message: photo.url, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        } else {
//            let alert = UIAlertController(title: "Alert", message: "Checkbox is disabled", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }
    
    
}

