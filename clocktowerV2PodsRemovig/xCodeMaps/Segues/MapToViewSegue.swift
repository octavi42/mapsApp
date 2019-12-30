//
//  MapToViewSegue.swift
//  xCodeMaps
//
//  Created by Cristea Octavian on 07/12/2019.
//  Copyright © 2019 Cristea Octavian. All rights reserved.
//

import UIKit

class MapToViewSegue: UIStoryboardSegue {
    
    override func perform() {
        animation()
    }
    
    func animation() {
        
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        fromViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
        toViewController.view.center = originalCenter
        toViewController.modalPresentationStyle = .fullScreen
        fromViewController.modalPresentationStyle = .fullScreen
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            
        }, completion: {
            success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
    
}
