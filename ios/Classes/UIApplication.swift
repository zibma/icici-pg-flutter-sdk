import UIKit

extension UIApplication {

  /// Safely locate a key window across iOS versions.
  public static func pp_keyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
      return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
    } else {
      return UIApplication.shared.keyWindow
    }
}


  /// Find the topmost presented view controller from the key window.
  public static func pp_topMostViewController(base: UIViewController? = UIApplication.pp_keyWindow()?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return pp_topMostViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
      return pp_topMostViewController(base: selected)
    }
    if let presented = base?.presentedViewController {
      return pp_topMostViewController(base: presented)
    }
    return base
  }
}
