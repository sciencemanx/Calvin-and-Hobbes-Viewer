//
//  StringFormatter.swift
//  Calvin and Hobbes
//
//  Created by Adam Van Prooyen on 10/3/16.
//  Copyright © 2016 Adam Van Prooyen. All rights reserved.
//

import Foundation
import UIKit

func attributeString(_ string: String) -> NSAttributedString {
    let attributedString = NSMutableAttributedString()
    let boldAttrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)]
    var isBold = false
    for c in string.characters {
        if (c == "_") {
            isBold = !isBold
        }
        else {
            if (isBold) {
                let boldString = NSMutableAttributedString(string: String(c), attributes: boldAttrs)
                attributedString.append(boldString)
            }
            else {
                let normalString = NSMutableAttributedString(string: String(c))
                attributedString.append(normalString)
            }
        }
    }
    return attributedString
}
