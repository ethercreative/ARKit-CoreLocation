//
//  LocationNode.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation
import SpriteKit

///A location node can be added to a scene using a coordinate.
///Its scale and position should not be adjusted, as these are used for scene layout purposes
///To adjust the scale and position of items within a node, you can add them to a child node and adjust them there
open class LocationNode: SCNNode {
    ///Location can be changed and confirmed later by SceneLocationView.
    public var location: CLLocation!
    
    ///Whether the location of the node has been confirmed.
    ///This is automatically set to true when you create a node using a location.
    ///Otherwise, this is false, and becomes true once the user moves 100m away from the node,
    ///except when the locationEstimateMethod is set to use Core Location data only,
    ///as then it becomes true immediately.
    public var locationConfirmed = false
    
    ///Whether a node's position should be adjusted on an ongoing basis
    ///based on its' given location.
    ///This only occurs when a node's location is within 100m of the user.
    ///Adjustment doesn't apply to nodes without a confirmed location.
    ///When this is set to false, the result is a smoother appearance.
    ///When this is set to true, this means a node may appear to jump around
    ///as the user's location estimates update,
    ///but the position is generally more accurate.
    ///Defaults to true.
    public var continuallyAdjustNodePositionWhenWithinRange = true
    
    ///Whether a node's position and scale should be updated automatically on a continual basis.
    ///This should only be set to false if you plan to manually update position and scale
    ///at regular intervals. You can do this with `SceneLocationView`'s `updatePositionOfLocationNode`.
    public var continuallyUpdatePositionAndScale = true
    
    public init(location: CLLocation?) {
        self.location = location
        self.locationConfirmed = location != nil
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class LocationAnnotationNode: LocationNode {
    ///An image to use for the annotation
    ///When viewed from a distance, the annotation will be seen at the size provided
    ///e.g. if the size is 100x100px, the annotation will take up approx 100x100 points on screen.
    public let image: UIImage
    
    public let titlePlace: String?
    
    ///Subnodes and adjustments should be applied to this subnode
    ///Required to allow scaling at the same time as having a 2D 'billboard' appearance
    public let annotationNode: SCNNode
    
    public let textNode: SCNNode
    
    ///Whether the node should be scaled relative to its distance from the camera
    ///Default value (false) scales it to visually appear at the same size no matter the distance
    ///Setting to true causes annotation nodes to scale like a regular node
    ///Scaling relative to distance may be useful with local navigation-based uses
    ///For landmarks in the distance, the default is correct
    public var scaleRelativeToDistance = false
    
    public init(location: CLLocation?, image: UIImage, titlePlace: String?) {
        self.image = image
        self.titlePlace = titlePlace
        
        let plane = SCNPlane(width: image.size.width / 150, height: image.size.height / 150)
        plane.firstMaterial!.diffuse.contents = image
        plane.firstMaterial!.lightingModel = .constant
        
        annotationNode = SCNNode()
        annotationNode.geometry = plane
        
        let skScene = SKScene(size: CGSize(width: 200, height: 120))
        skScene.backgroundColor = UIColor.clear
        skScene.zRotation = .pi
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 120), cornerRadius: 10)
        rectangle.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        rectangle.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        rectangle.lineWidth = 3
        rectangle.alpha = 0.8
        let labelNode = SKLabelNode(text: "Hello World askjd laskjd las kjd")
        
        labelNode.fontSize = 20
        labelNode.fontName = "San Fransisco"
        labelNode.position = CGPoint(x:100,y:60)
        labelNode.fontColor = UIColor.black
        
        skScene.addChild(rectangle)
        skScene.addChild(labelNode)
        
        let plane1 = SCNPlane(width: 20, height: 12)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane1.materials = [material]
        
        textNode = SCNNode(geometry: plane1)
        textNode.pivot = SCNMatrix4MakeRotation(.pi, 1, 0, 0)
        textNode.position = SCNVector3(0.0, Float(plane.height / 2 + plane1.height / 2.0), 0.0)
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        addChildNode(annotationNode)
        addChildNode(textNode)
        
//        let text = SCNText(string: titlePlace, extrusionDepth: 0.1)
//        text.font = .systemFont(ofSize: 5)
//        text.flatness = 0.3
//        text.chamferRadius = 0.5
//        text.firstMaterial?.diffuse.contents = UIColor.white
//        text.alignmentMode  = kCAAlignmentCenter
//        text.truncationMode = kCATruncationEnd
//        text.firstMaterial?.isDoubleSided = true
//
//        let textWrapperNode = SCNNode(geometry: text)
//        textWrapperNode.position = SCNVector3(0.0, Float(plane.height + 5), 0.0)
//        textWrapperNode.scale = SCNVector3(1/2.0, 1/2.0, 1/2.0)
//
//        let textBubble = SCNPlane(sources: (textWrapperNode.geometry?.sources)!, elements: [])
//        textBubble.firstMaterial?.diffuse.contents = image
//        let nodeBubble = SCNNode(geometry: textBubble)
//
//        addChildNode(nodeBubble)
//        addChildNode(textWrapperNode)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
