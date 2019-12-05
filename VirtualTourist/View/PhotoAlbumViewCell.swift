//
//  PhotoAlbumViewCell.swift
//  VirtualTourist
//
//  Created by Faisal Babkoor on 12/5/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class PhotoAlbumViewCell: UICollectionViewCell {
    @IBOutlet var photoAlbum: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    func configureCell(photo: Photo) {
//        spinner.isHidden = false
//        spinner.startAnimating()
//        guard let imageData = photo.image else { return }
//        self.photoAlbum.image = UIImage(data: imageData)
//        spinner.stopAnimating()
    }
}
