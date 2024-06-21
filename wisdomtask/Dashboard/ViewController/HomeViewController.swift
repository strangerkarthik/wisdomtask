//
//  HomeViewController.swift
//  wisdomtask
//
//  Created by JAISHIVA SN on 21/06/24.
//

import UIKit
import Foundation
  
// HomeViewController: Handles the main view, which displays a collection of photos in a table view.
class HomeViewController: UIViewController {
    // IBOutlet for the table view that will display the photo collection.
    @IBOutlet weak var photocollectiontable: UITableView!
    
    // Activity indicator to show loading progress.
    var activityIndicator: UIActivityIndicatorView?
    // Lazy initialization of the view model.
    lazy var viewModel = {
       return HomeViewModel()
    }()
    // Called after the controller's view is loaded into memory.

    override func viewDidLoad() {
       super.viewDidLoad()
       tablesetup()
        // Delay the execution of showing the activity indicator and fetching photos by 1 second.
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.showActivityIndicator()
        self.viewModel.fetchphotos(page: self.viewModel.currentPage, completion: {
            self.updateData()
        })
        })
    }
    // Called when the system determines that the amount of available memory is low.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("receive memory warning")
    }
    // Set up the table view, including its delegate, data source, and refresh control.
    func tablesetup() {
        photocollectiontable.delegate = self
        photocollectiontable.dataSource = self
        photocollectiontable.refreshControl = UIRefreshControl()
        photocollectiontable.refreshControl?.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        setupActivityIndicator()
    }
    // Initialize and configure the activity indicator.
    func setupActivityIndicator() {
            activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .red
            guard let activityIndicator = activityIndicator else { return }
            
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            photocollectiontable.addSubview(activityIndicator)
        }
    // Show the activity indicator and hide it after 10 seconds.
        func showActivityIndicator() {
            activityIndicator?.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now()+10, execute: {
                self.hideActivityIndicator()
            })
        }

        // Hide the activity indicator.
        func hideActivityIndicator() {
            self.activityIndicator?.stopAnimating()
        }

    // Refresh the photos by resetting the view model and fetching the first page of photos.
    
    @objc func refreshPhotos() {
        viewModel.currentPage = 1
        viewModel.getphotodatails.removeAll()
        viewModel.photoList.removeAll()
        self.photocollectiontable.reloadData()
        self.viewModel.fetchphotos(page: self.viewModel.currentPage, completion: {
            self.updateData()
        })
    }
    
    // Update the data in the table view after a delay.
    func updateData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            
            self.photocollectiontable.refreshControl?.endRefreshing()
            self.photocollectiontable.reloadData()
            self.loadImages()
        })
        
    }
    
    // Load images asynchronously from URLs and update the view model with the images.
        
    func loadImages() {
        for i in 0..<self.viewModel.getphotodatails.count {
            guard let urlfromimage = self.viewModel.getphotodatails[i].download_url else {
                return
            }
            if let url = URL(string: urlfromimage) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
//                            self.getphotodatails[i].photoImageData = data
                            if self.viewModel.getphotodatails.indices.contains(i) {
                                let id = self.viewModel.getphotodatails[i].id ?? ""
                                let photo = Photos.init(id: id, author: self.viewModel.getphotodatails[i].author ?? "", photoImageData: image, check: false)
                                let found = self.viewModel.photoList.filter({ ($0.id ?? "").contains(id) })
                                if found.isEmpty {
                                    self.viewModel.photoList.append(photo)
                                }
                                if self.viewModel.getphotodatails.count == self.viewModel.photoList.count {
                                    self.viewModel.photoList = self.viewModel.photoList.sorted(by: { Int($0.id ?? "0") ?? 0 < Int($1.id ?? "0") ?? 0 })
                                    self.hideActivityIndicator()
                                    self.photocollectiontable.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        self.hideActivityIndicator()
    }
    
}

// Return the number of rows in the section.

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.photoList.count
    }
    // Configure and return the cell for the given index path.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photocollectiontable.dequeueReusableCell(withIdentifier: "photocell", for: indexPath) as! FetchTableViewCell
        if self.viewModel.photoList.indices.contains(indexPath.row) {
            let photoindex = self.viewModel.photoList[indexPath.row]
            cell.config(photo: photoindex)
            cell.checkBoxBtn.tag = indexPath.row
            cell.checkBoxBtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .valueChanged)
            cell.descriptionLabel.text = indexPath.row % 2 == 0 ? "Apple iOS is the operating system for iPhone, iPad, and other Apple mobile devices." : "Based on Mac OS, the operating system which runs Apple's line of Mac desktop and laptop computers, Apple iOS is designed for easy, seamless networking among a range of Apple products."
            cell.descriptionLabel.numberOfLines = 0
            cell.descriptionLabel.lineBreakMode = .byWordWrapping
            cell.descriptionLabel.sizeToFit()
            cell.checkBox.image = UIImage(named: (photoindex.check ?? false) ? "checkbox" : "uncheck")
            cell.checkBoxTapped = { status in
                self.viewModel.photoList[indexPath.row].check = status
                cell.checkBox.image = UIImage(named: status ? "checkbox" : "uncheck")
                self.photocollectiontable.reloadData()
                self.showAlert(status: status, title: cell.titleLabel.text!)
                
            }
//            if indexPath.row == photoList.count - 15 && !isLoading {
//                currentPage += 1
//                fetchphotos(page: currentPage)
//            }
        }
        return cell
    }
    
    // Handle the checkbox tap action and display the photo URL in an alert.
    
    @objc func checkboxTapped(_ sender: UISwitch) {
        let photo = viewModel.getphotodatails[sender.tag]
           let message = photo.url
           let alert = UIAlertController(title: "Photo URL", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
    }
    
    // Show an alert indicating the selection status of the photo.
    
    func showAlert(status: Bool, title: String) {
        let alertVC = UIAlertController(title: title, message: status ? "\(title) is Selected" : "\(title) is UnSelected", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true)
    }
    
}
// Return the automatic dimension for the row height.

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Handle the event when a cell is about to be displayed.
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photoList.count - 15 { // Last cell
            if viewModel.currentPage < viewModel.totalPages {
                viewModel.currentPage += 1
                viewModel.fetchphotos(page: viewModel.currentPage, completion: {
                    self.updateData()
                })
            }
        }
    }
        
    
}


