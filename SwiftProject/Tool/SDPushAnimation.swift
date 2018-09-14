//
//  SDPushAnimationController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/9/13.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit

class SDPushAnimation: NSObject{
    
    var transitionContext : UIViewControllerContextTransitioning?

}

extension SDPushAnimation : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext : UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        let containView = transitionContext.containerView
        
        UIView.animate(withDuration: duration / 2, animations: {
            fromViewController.view.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 1, 0)
        })
        containView.addSubview(toViewController.view)
        toViewController.view.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 1, 0)
        UIView.animate(withDuration: duration / 2, delay: duration / 2, options: .curveEaseOut, animations: {
            toViewController.view.layer.transform = CATransform3DIdentity
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}


//present
extension SDPushAnimation: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self
//    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

//push pop
extension SDPushAnimation : UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
       
    }
}
