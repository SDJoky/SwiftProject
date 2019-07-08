//
//  TestTableViewCell.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/9/14.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var photoImgV: UIImageView!
    @IBOutlet weak var desLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension TestTableViewCell {
    static func cellHeigh() -> CGFloat {
        return 180
    }
}
