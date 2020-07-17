//
//  CustomeNavigationBar.swift
//  hiraafood-xcode-10
//
//  Created by Pinaki Poddar on 7/17/20.
//  Copyright © 2020 Digital Artisan. All rights reserved.
//

import UIKit

class CustomeNavigationBar: UINavigationBar {

    var left:UIButton
    var right:UIButton
    var title:UILabel
    
    init() {
        left = UIButton()
        right = UIButton()
        title = UILabel()
        super.init(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height: 64))
        backgroundColor = .blue
        title.text = "TITLE"
        left.setTitle("left", for: .normal)
        right.setTitle("right", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(left)
        addSubview(title)
        addSubview(right)
        super.layoutSubviews()
    }

}
