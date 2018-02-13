//
//  MaskDecode.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 13.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation


class MaskDecode {
    class func decodeMask(i: Int)-> [Int] {
        
        let array = [1,2,4,8,16,32,64,128,256,512]
        var binary = [Int]()
        for b in array {
            if i&b == 0 {
                binary.append(0)
            } else {
                binary.append(1)
            }
        }
        
        return binary
        
    }
}
