//
//  ViewController.swift
//  ARWho
//
//  Created by Le-Sang Nguyen on 7/29/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ScanViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var people: People?
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let trackingImage = ARReferenceImage.referenceImages(inGroupNamed: "Scientists", bundle: nil) else {
            fatalError("Couldn't load tracking images")
        }
        configuration.trackingImages = trackingImage
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        guard let id = imageAnchor.referenceImage.name else { return nil }
        let link = "http:/192.168.1.19:5000/people/\(id)" // thay bằng IP Address của Mạng
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        let node = SCNNode()
        node.addChildNode(planeNode)
        NetworkService(link)
            .setMethod(.get)
            .get(ListRequest.parser) { result in
                switch result {
                case let .success(value):
                    self.people = value[0].people[0]
                    print(self.people!)
                    let spacing: Float = 0.005
                    let titleNode = self.textNode(self.people!.name, font: UIFont.boldSystemFont(ofSize: 8), color: UIColor.blue)
                    titleNode.pivotOnTopLeft()
                    titleNode.position.x += Float(plane.width / 2) + spacing
                    titleNode.position.y += Float(plane.height / 2)
                    planeNode.addChildNode(titleNode)
                    let bioNode = self.textNode(self.people!.bio, font: UIFont.systemFont(ofSize: 3), maxWidth: 60, color: UIColor.white)
                    bioNode.pivotOnTopLeft()
                    bioNode.position.x += Float(plane.width / 2) + spacing
                    bioNode.position.y = titleNode.position.y - titleNode.height - spacing
                    planeNode.addChildNode(bioNode)
                    let flag = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width / 8 * 5)
                    flag.firstMaterial?.diffuse.contents = UIImage(named: self.people!.country)
                    let flagNode = SCNNode(geometry: flag)
                    flagNode.pivotOnTopCenter()
                    flagNode.position.y -= Float(plane.height / 2) + spacing
                    planeNode.addChildNode(flagNode)
                case let .failure(error):
                    print(error)
                }
        }
        return node
    }
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil, color: UIColor) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        
        text.flatness = 0.1
        text.font = font
        text.firstMaterial?.diffuse.contents = color
        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }
        
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        
        return textNode
    }
}

extension SCNNode {
    var width: Float {
        return (boundingBox.max.x - boundingBox.min.x) * scale.x
    }
    
    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }
    
    func pivotOnTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
    }
    
    func pivotOnTopCenter() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
    }
}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

