//
//  ViewController.swift
//  Mugshot
//
//  Created by taco on 7/26/19.
//  Copyright © 2019 tacoTruck. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var scientists = [String: Scientist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "scientists", bundle: nil) else {
            fatalError("Couldn't load tracking images")
        }
        
        configuration.trackingImages = trackingImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "scientists", withExtension: "json") else {
            fatalError("Unable to find JSON in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load JSON")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedScientists = try? decoder.decode([String: Scientist].self, from: data) else {
            fatalError("Unable to parse JSON.")
        }
        
        scientists = loadedScientists
    }
    
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        
        text.flatness = 0.1
        text.font = font
        
        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }
        
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        
        return textNode
    }
}
