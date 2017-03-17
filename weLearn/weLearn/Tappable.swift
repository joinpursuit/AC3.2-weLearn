//
//  Tappable.swift
//  weLearn
//
//  Created by Marty Avedon on 3/9/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

// so we can click buttons on cells and have them behave properly...

protocol Tappable {
    func cellTapped(cell: UITableViewCell)
}
