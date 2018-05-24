//
//  CircleView.swift
//  MyAppointments
//
//  Created by Aleksei Degtiarev on 23/05/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    
    @IBInspectable var isRound: Bool = false {
        
        didSet {
            if isRound {
                setupView()
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if isRound {
            setupView()
        }
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        //        self.layer.borderWidth = 1.0
    }
}
