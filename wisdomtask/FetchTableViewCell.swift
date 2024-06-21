//
//  fetchTableViewCell.swift
//  wisdomtask
//
//  Created by JAISHIVA SN on 21/06/24.
//

import UIKit

// FetchTableViewCell: Custom UITableViewCell that represents each cell in the table view.
class FetchTableViewCell: UITableViewCell {
  
    // IBOutlets for the UI components in the cell.
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    // Closure that is called when the checkbox is tapped, passing the new check status.
    var checkBoxTapped: ((Bool) -> Void)?
    // Boolean to keep track of the checkbox state.
    var check = false
    
    // Called after the view has been loaded from the nib file.
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
        subView.layer.cornerRadius = 5
    }
    
    // Configure the cell with photo data.
    func config(photo: Photos) {//photodetails){
        self.photoImage.image = nil
        let sno = Int(photo.id ?? "1") ?? 1
        
        // Set the title label with the photo's serial number and author.
        titleLabel.text = "\(sno+1) " + "\(photo.author ?? "None")"
        
        // Set the photo image if image data is available.
        if let data = photo.photoImageData {
            photoImage.image = data//UIImage(data: data)
        }
    }

    @IBAction func checkboxTapped(_ sender: UIButton) {
        if check {
            check = false
        } else {
            check = true
        }
        // Call the closure to notify about the check state change.
        self.checkBoxTapped?(self.check)
    }
    
    // Called to set the selected state of the cell.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
