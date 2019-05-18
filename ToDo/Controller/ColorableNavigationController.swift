//
//  ColorableNavigationController.swift
//  ToDo
//
//  Created by Vladimir Korolev on 18/05/2019.
//  Copyright © 2019 Vladimir Brejcha. All rights reserved.
//

//
//  ColorableNavigationController.swift
//
//  Created by Vasily Ulianov on 26.10.16.
//
import UIKit

/// Navigation bar colors for `ColorableNavigationController`, called on `push` & `pop` actions
public protocol NavigationBarColorable: class {
  var navigationTintColor: UIColor? { get }
  var navigationBarTintColor: UIColor? { get }
}

public extension NavigationBarColorable {
  var navigationTintColor: UIColor? { return nil }
}

/**
 UINavigationController with different colors support of UINavigationBar.
 To use it please adopt needed child view controllers to protocol `NavigationBarColorable`.
 - note: Don't forget to set initial tint and barTint colors
 */
open class ColorableNavigationController: UINavigationController {
  private var previousViewController: UIViewController? {
    guard viewControllers.count > 1 else {
      return nil
    }
    return viewControllers[viewControllers.count - 2]
  }
  
  override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
    if let colors = viewController as? NavigationBarColorable {
      self.setNavigationBarColors(colors)
    }
    
    super.pushViewController(viewController, animated: animated)
  }
  
  override open func popViewController(animated: Bool) -> UIViewController? {
    if let colors = self.previousViewController as? NavigationBarColorable {
      self.setNavigationBarColors(colors)
    }
    
    // Let's start pop action or we can't get transitionCoordinator()
    let popViewController = super.popViewController(animated: animated)
    
    // Secure situation if user cancelled transition
    transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] (context) in
      guard let colors = self?.topViewController as? NavigationBarColorable else { return }
      self?.setNavigationBarColors(colors)
    })
    
    return popViewController
  }
  
  private func setNavigationBarColors(_ colors: NavigationBarColorable) {
    if let tintColor = colors.navigationTintColor {
      self.navigationBar.tintColor = tintColor
    }
    
    self.navigationBar.barTintColor = colors.navigationBarTintColor
  }
}
