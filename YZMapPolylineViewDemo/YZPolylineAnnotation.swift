//
//  YZPolylineAnnotation.swift
//  YZMapPolylineViewDemo
//
//  Created by Lester 's Mac on 2021/9/1.
//

import MapKit

class YZPolylineAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String?
    var subtitle: String?
    var imagename: String?

}
