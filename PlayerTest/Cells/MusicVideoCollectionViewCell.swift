//
//  MusicVideoCollectionViewCell.swift
//  PlayerTest
//
//  Created by Fernanda de Lima on 18/01/2018.
//  Copyright © 2018 Empresinha. All rights reserved.
//

import UIKit

class MusicVideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iTunnesButton: UIButton!
    
    @IBAction func goiTunnesActionButton(_ sender: UIButton) {
        if let url = URL(string: (mm.response?.results![sender.tag].artistViewUrl)!){
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //If you want handle the completion block than
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        videoImage.layer.cornerRadius = 4
        
    }

}
