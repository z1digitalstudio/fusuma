//
//  FSAlbumViewCell.swift
//  Fusuma
//
//  Created by Yuta Akizuki on 2015/11/14.
//  Copyright © 2015年 ytakzk. All rights reserved.
//

import UIKit
import Photos

final class FSAlbumViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkmarkImageView: UIImageView! {
        didSet {
            checkmarkImageView.isHidden = true
        }
    }

    var selectedLayer = CALayer()

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        isSelected = false
        selectedLayer.backgroundColor = fusumaSelectColor.cgColor
        if let image = fusumaSelectImage {
            checkmarkImageView.image = image
        }
    }

    override var isSelected : Bool {
        didSet {
            if selectedLayer.superlayer == imageView.layer {
                selectedLayer.removeFromSuperlayer()
                checkmarkImageView.isHidden = true
            }

            if isSelected {
                selectedLayer.frame = self.bounds
                imageView.layer.addSublayer(selectedLayer)
                checkmarkImageView.isHidden = false
            }
        }
    }
}
