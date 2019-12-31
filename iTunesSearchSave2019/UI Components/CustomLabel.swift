//
//  CustomLabel.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 27/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    enum Style {
        case regular
        case light
        case bolded
        case small
        case header
    }

    
    init(text: String? = nil, alignment: NSTextAlignment = .left, numberOfLines: Int = 0, style: Style = .regular) {
        super.init(frame: .zero)
        switch style {
        case .regular:
            self.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            self.textColor = .black
        case .light:
            self.font = UIFont.systemFont(ofSize: 14, weight: .light)
            self.textColor = .gray
        case .bolded:
            self.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            self.textColor = .black
        case .small:
            self.font = UIFont.systemFont(ofSize: 14, weight: .light)
            self.textColor = .gray
        case .header:
            self.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            self.textColor = .black
        }
        
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.text = text
    }
    
    func setCustomFontWith(size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.textColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
