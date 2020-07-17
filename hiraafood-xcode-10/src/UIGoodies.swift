//
//  UIGoodies.swift
//  hiraafood-xcode-10
//
//  Created by Pinaki Poddar on 7/15/20.
//  Copyright © 2020 Digital Artisan. All rights reserved.
//

import UIKit

class Rating:  UIStackView {
    static let MAX_RATING = 5
    init(_ rating:Int) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .fill
        distribution = .fill
        for i in 1...Rating.MAX_RATING {
            let subview = i <= rating ? star_filled() : star_unfilled()
            subview.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(subview)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func star_filled () -> UIImageView {
        return UIImageView(image:
            ImageLibrary().getImage(name:"star_filled"))
    }
    
    func star_unfilled () -> UIImageView {
        return UIImageView(image:
            ImageLibrary().getImage(name:"star_unfilled"))
    }
    
    public override var intrinsicContentSize: CGSize {
        let w = CGFloat(Rating.MAX_RATING) *
            (star_filled().image?.size.width ?? 24)
        let h = star_filled().image?.size.height ?? 24
        
        return CGSize(width: w, height: h)
    }
}





class Spacer: UIView {
    var axis:NSLayoutConstraint.Axis
    init(axis:NSLayoutConstraint.Axis) {
        self.axis = axis
        super.init(frame:.zero)
        //backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        setContentCompressionResistancePriority(.defaultLow, for: axis)
        setContentCompressionResistancePriority(.defaultHigh, for: axis)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        switch axis {
        case .horizontal:
            return CGSize(width: 100, height: 12)
        case .vertical:
            return CGSize(width: 12, height: 40)
        default:
            fatalError()
        }
    }
}
/*
 * Button on section header to show/hide a section
 */
class CollapsibleButton :UIButton {
    var section:Int
    var owner:MenuView
    static let side = CGFloat(16.0)
    static let HIDDEN:String = "\u{25B6}"//H
    static let SHOWN:String  = "\u{25BC}"//S
    
    init(owner:MenuView, section:Int) {
        self.owner   = owner
        self.section = section
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        self.setCurrentTitle()
        addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toggleSection() {
        print("********** YAHOO *********** toggle \(section)")
        self.owner.toggleSection(section: self.section)
        setCurrentTitle()
    }
    
    func setCurrentTitle() {
        let title = self.owner.isHidden(self.section)
            ? CollapsibleButton.HIDDEN
            : CollapsibleButton.SHOWN
        
        print("set collapsible button title for section \(section) to title \(title) ")
        
        self.setTitle(title, for:.normal)
    }
}
