//
//  YZGradientPathRenderer.swift
//  YZMapPolylineViewDemo
//
//  Created by Lester 's Mac on 2021/9/1.
//

import MapKit

class YZGradientPathRenderer: MKOverlayPathRenderer {

    var polyline: MKPolyline
    var colors: [UIColor]
    var showsBorder: Bool = false
    var borderColor: UIColor?
    private var cgColors: [CGColor] {
        return colors.map({ (color) -> CGColor in
            return color.cgColor
        })
    }
    
    init(polyline: MKPolyline, colors: [UIColor]) {
        self.polyline = polyline
        self.colors = colors
        
        super.init(overlay: polyline)
    }
    
    init(polyline: MKPolyline, colors: [UIColor], showsBorder: Bool, borderColor: UIColor) {
        self.polyline = polyline
        self.colors = colors
        self.showsBorder = showsBorder
        self.borderColor = borderColor
        
        super.init(overlay: polyline)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let baseWidth: CGFloat = self.lineWidth / zoomScale
        
        if self.showsBorder {
            context.setLineWidth(baseWidth * 2)
            context.setLineJoin(CGLineJoin.round)
            context.setLineCap(CGLineCap.round)
            context.addPath(self.path)
            context.setStrokeColor(self.borderColor?.cgColor ?? UIColor.white.cgColor)
            context.strokePath()
        }
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let stopValues = calculateNumberOfStops()
        let locations: [CGFloat] = stopValues
        let gradient = CGGradient(colorsSpace: colorspace, colors: cgColors as CFArray, locations: locations)
    
        context.setLineWidth(baseWidth)
        context.setLineJoin(CGLineJoin.round)
        context.setLineCap(CGLineCap.round)
        
        context.addPath(self.path)
        
        context.saveGState();
        
        context.replacePathWithStrokedPath()
        context.clip();

        let boundingBox = self.path.boundingBoxOfPath
        let gradientStart = boundingBox.origin
        let gradientEnd   = CGPoint(x:boundingBox.maxX, y:boundingBox.maxY)

        if let gradient = gradient {
            context.drawLinearGradient(gradient, start: gradientStart, end: gradientEnd, options: CGGradientDrawingOptions.drawsBeforeStartLocation);
        }
        
        
        context.restoreGState()
        
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
    
    
    override func createPath() {
        let path: CGMutablePath  = CGMutablePath()
        var pathIsEmpty: Bool = true
        
        for i in 0...self.polyline.pointCount-1 {
            
            let point: CGPoint = self.point(for: self.polyline.points()[i])
            if pathIsEmpty {
                path.move(to: point)
                pathIsEmpty = false
            } else {
                path.addLine(to: point)
            }
        }
        self.path = path
    }
    
    
    private func calculateNumberOfStops() -> [CGFloat] {
        
        let stopDifference = (1 / Double(cgColors.count))
        
        return Array(stride(from: 0, to: 1+stopDifference, by: stopDifference))
            .map { (value) -> CGFloat in
                return CGFloat(value)
        }
    }
    
}
