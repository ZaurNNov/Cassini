//
//  ImageViewController.swift
//  Cassini
//
//  Created by User on 13.10.2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
    // MARK: User Interface
    
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet {
            // to zoom we have to handle viewForZooming(in scrollView:)
            scrollView.delegate = self
            
            // and we must set our minimum and maximum zoom scale
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            
            // most important thing to set in UIScrollView is contentSize
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    private var image : UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            // careful here because scrollView might be nil
            // (for example, if we're setting our image as part of a prepare)
            // so use optional chaining to do nothing
            // if our scrollView outlet has not yet been set
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    // MARK: Private Implementation
    
    private func fetchImage() {
        if let url = imageURL {
            // this next line of code can throw an error
            // and it also will block the UI entirely while access the network
            // we really should be doing it in a separate thread
            
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                let urlContents = try? Data(contentsOf: url)
                
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageURL = DemoURL.stanford  // for demo/testing purposes only
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil { // we're about to appear on screen so, if needed,
            fetchImage() // fetch image
        }
    }

    // MARK: Model
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil { // if we're on screen
                fetchImage()        // then fetch image
            }
        }
    }
}

// MARK: UIScrollViewDelegate
// Extension which makes ImageViewController conform to UIScrollViewDelegate
// Handles viewForZooming(in scrollView:)
// by returning the UIImageView as the view to transform when zooming

extension ImageViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
