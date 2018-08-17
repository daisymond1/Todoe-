//
//  Item.swift
//  Todoe🏀
//
//  Created by Daisymond on 8/16/18.
//  Copyright © 2018 Daisymond. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
}
