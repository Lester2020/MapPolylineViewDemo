//
//  ViewController.swift
//  YZMapPolylineViewDemo
//
//  Created by Lester 's Mac on 2021/9/1.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    private lazy var mapView: MKMapView = {
        let view = MKMapView.init()
        view.delegate = self
        view.showsCompass = true
        view.showsUserLocation = true
        return view
    }()
    
    private let routes = Array([
        CLLocationCoordinate2D(latitude: 39.996356, longitude: 116.480639),
        CLLocationCoordinate2D(latitude: 39.996426, longitude: 116.478440),
        CLLocationCoordinate2D(latitude: 39.995818, longitude: 116.477753),
        CLLocationCoordinate2D(latitude: 39.996426, longitude: 116.476884),
        CLLocationCoordinate2D(latitude: 39.997355, longitude: 116.475371),
        CLLocationCoordinate2D(latitude: 39.998152, longitude: 116.474191),
        CLLocationCoordinate2D(latitude: 39.999787, longitude: 116.471745),
        CLLocationCoordinate2D(latitude: 39.999138, longitude: 116.470618),
        CLLocationCoordinate2D(latitude: 39.998587, longitude: 116.469406),
        CLLocationCoordinate2D(latitude: 39.997815, longitude: 116.468623),
        CLLocationCoordinate2D(latitude: 39.99719, longitude: 116.467711),
        CLLocationCoordinate2D(latitude: 39.997083, longitude: 116.465662),
        CLLocationCoordinate2D(latitude: 39.997026, longitude: 116.46269),
        CLLocationCoordinate2D(latitude: 39.996927, longitude: 116.457357),
        CLLocationCoordinate2D(latitude: 39.996771, longitude: 116.453538),
        CLLocationCoordinate2D(latitude: 39.996155, longitude: 116.451435),
        CLLocationCoordinate2D(latitude: 39.995777, longitude: 116.449869),
        CLLocationCoordinate2D(latitude: 39.995382, longitude: 116.448624),
        CLLocationCoordinate2D(latitude: 39.995226, longitude: 116.447036),
        CLLocationCoordinate2D(latitude: 39.99539, longitude: 116.443281),
        CLLocationCoordinate2D(latitude: 39.998053, longitude: 116.438464),
        CLLocationCoordinate2D(latitude: 40.000297, longitude: 116.434473),
        CLLocationCoordinate2D(latitude: 40.001135, longitude: 116.430932),
        CLLocationCoordinate2D(latitude: 40.00139, longitude: 116.428368),
        CLLocationCoordinate2D(latitude: 40.002491, longitude: 116.425085),
        CLLocationCoordinate2D(latitude: 40.003141, longitude: 116.418798),
        CLLocationCoordinate2D(latitude: 40.003116, longitude: 116.417478),
        CLLocationCoordinate2D(latitude: 40.00388, longitude: 116.417382),
        CLLocationCoordinate2D(latitude: 40.004998, longitude: 116.417178),
        CLLocationCoordinate2D(latitude: 40.008104, longitude: 116.416609),
        CLLocationCoordinate2D(latitude: 40.011745, longitude: 116.416255),
        CLLocationCoordinate2D(latitude: 40.01771, longitude: 116.417328),
        CLLocationCoordinate2D(latitude: 40.027307, longitude: 116.418015),
        CLLocationCoordinate2D(latitude: 40.030461, longitude: 116.418068),
        CLLocationCoordinate2D(latitude: 40.032696, longitude: 116.417897),
        CLLocationCoordinate2D(latitude: 40.034528, longitude: 116.417511),
        CLLocationCoordinate2D(latitude: 40.036861, longitude: 116.416266),
        CLLocationCoordinate2D(latitude: 40.039399, longitude: 116.415472),
        CLLocationCoordinate2D(latitude: 40.040812, longitude: 116.415097),
        CLLocationCoordinate2D(latitude: 40.041961, longitude: 116.414453),
        CLLocationCoordinate2D(latitude: 40.044393, longitude: 116.413112),
        CLLocationCoordinate2D(latitude: 40.046347, longitude: 116.411535),
        CLLocationCoordinate2D(latitude: 40.047119, longitude: 116.411202),
        CLLocationCoordinate2D(latitude: 40.050372, longitude: 116.410998),
        CLLocationCoordinate2D(latitude: 40.051908, longitude: 116.411545),
        CLLocationCoordinate2D(latitude: 40.053074, longitude: 116.412361),
        CLLocationCoordinate2D(latitude: 40.054634, longitude: 116.413412),
        CLLocationCoordinate2D(latitude: 40.056416, longitude: 116.413562),
        CLLocationCoordinate2D(latitude: 40.058108, longitude: 116.413391),
        CLLocationCoordinate2D(latitude: 40.061606, longitude: 116.41308),
        CLLocationCoordinate2D(latitude: 40.065169, longitude: 116.412822),
        CLLocationCoordinate2D(latitude: 40.066606, longitude: 116.412661)
    ])
    
    private var count = -1
    private var polyline: MKPolyline?
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.frame = view.bounds
        view.addSubview(mapView)
        
        let center = MKPolyline(coordinates: routes, count: routes.count).coordinate
        let camera = MKMapCamera(lookingAtCenter: center, fromDistance: 30000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(YZPolylineAnnotation.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    private func startTimer() {
        if timer != nil {
            stopTimer()
        }
        
        count = -1
        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerAction() {
        count += 1
        
        if let previous = polyline {
            mapView.removeOverlay(previous)
            polyline = nil
        }
        
        if count == 0 {
            addStartAnnotation()
        }
        
        let subCoordinates = Array(routes.prefix(upTo: count))
        let overlay = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
        mapView.addOverlay(overlay)
        polyline = overlay
        
        if count == routes.count - 1 {
            stopTimer()
            addEndAnnotation()
        }
    }
    
    private func addStartAnnotation() {
        if let startCoordinate = routes.first {
            let annotation = YZPolylineAnnotation()
            annotation.coordinate = startCoordinate
            annotation.imagename = "map_qidian"
            annotation.title = "起点"
            annotation.subtitle = "望京SOHO"
            mapView.addAnnotation(annotation)
        }
    }
    
    private func addEndAnnotation() {
        if let endCoordinate = routes.last {
            let annotation = YZPolylineAnnotation()
            annotation.coordinate = endCoordinate
            annotation.imagename = "map_zhongdian"
            annotation.title = "终点"
            annotation.subtitle = "目的地"
            mapView.addAnnotation(annotation)
        }
    }
    

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer() }

        let gradientColors = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.red]
        let polylineRenderer = YZGradientPathRenderer(polyline: polyline, colors: gradientColors)
        polylineRenderer.lineWidth = 10
        polylineRenderer.lineJoin = .round
        polylineRenderer.lineCap = .round

        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? YZPolylineAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(YZPolylineAnnotation.self), for: annotation)
            if let annotationView = annotationView {
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: annotation.imagename ?? "")!
            }
        }
        return annotationView
    }


}

