//
//  CassiniViewController.swift
//  Cassini
//
//  Created by User on 13.10.2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {


    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            
            if let imageVC = (segue.destination.contents as? ImageViewController) {
                imageVC.imageURL = url
                imageVC.title = (sender as? UIButton)?.currentTitle
            }
        }
    }

}

//its cool extention :)
extension UIViewController
{
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
