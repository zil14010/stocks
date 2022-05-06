//
//  Theme.swift
//  stocks
//
//  Created by zipeng lin on 4/29/22.
//  Copyright © 2022 dk. All rights reserved.
//

import UIKit

struct Theme {

    static let attributes = [ NSAttributedString.Key.foregroundColor: color ]

    static var closeButton: UIBarButtonItem {
        let image = UIImage(systemName: "xmark")
        let button = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        button.tintColor = Theme.color

        return button
    }

    static let color = UIColor.systemTeal

    static let separator = " · "

}
