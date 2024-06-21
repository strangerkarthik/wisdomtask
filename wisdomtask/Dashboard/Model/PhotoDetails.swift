//
//  PhotoDetails.swift
//  wisdomtask
//
//  Created by JAISHIVA SN on 22/06/24.
//

import Foundation

struct photodetails: Codable {
    var id: String?
    var author: String?
    var width: Int?
    var height: Int?
    var url: String?
    var download_url: String?
    var photoImageData: Data?
}
