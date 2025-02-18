//
//  DistanceAnnotation.swift
//  travelMap
//
//  Created by green on 15/7/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import MapKit

class DistanceAnnotation: MKPointAnnotation {
    
    var distance: String!
    
    init(latitude:CLLocationDegrees, longitude: CLLocationDegrees, distance: String) {
        
        super.init()
        super.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.distance = distance
    }
    
    // MARK: - 重写比较方法
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? DistanceAnnotation {
            
            if object.coordinate.latitude == self.coordinate.latitude && object.coordinate.longitude == self.coordinate.longitude {
                
                return true
            }
        }
        return false
    }
    
    override var hash: Int {
        
        get {
            
            return "\(self.coordinate.latitude)\(self.coordinate.longitude)".hash
        }
    }
}
