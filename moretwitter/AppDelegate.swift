//
//  AppDelegate.swift
//  moretwitter
//
//  Created by Faheem Hussain on 11/5/16.
//  Copyright © 2016 Faheem Hussain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if User.current != nil {
            TwitterClient.shared?.currentUser(success: { (user: User) in
                self.navigateAfterLogin()
            }, failure: { (error: Error) in
                print("Error Verifying: \(error.localizedDescription)")
            })
            
        }
        NotificationCenter.default.addObserver(forName: TwitterClient.userDidLogoutNotification, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = loginViewController
            
        }
        NotificationCenter.default.addObserver(forName: TwitterClient.userDidLoginNotification, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.navigateAfterLogin()
            
        }
        return true
    }
    func navigateAfterLogin(){
        //let loginViewController = window?.rootViewController as! LoginViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
        self.window?.rootViewController = hamburgerViewController
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.menuViewController = menuViewController
        //loginViewController.performSegue(withIdentifier: "LoginAndShowHome", sender: loginViewController)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.shared?.handleOpenUrl(url: url)
        return true
    }


}


extension DateFormatter {
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
     
     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".
     
     - Returns: A string with formatted `date`.
     */
    func timeSince(from: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = from //(now > from ? from : now)
        let latest = now //earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest)
        
        var result = ""
        
        if components.year! >= 2 {
            result = "\(components.year!)y"
        } else if components.year! >= 1 {
            if numericDates {
                result = "1y"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!)m"
        } else if components.month! >= 1 {
            if numericDates {
                result = "1m"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!)w"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = "1w"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!)d"
        } else if components.day! >= 1 {
            if numericDates {
                result = "1d"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!)d"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1h"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!)m"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1m"
            } else {
                result = "A minute ago"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!)s"
        } else {
            result = "Just now"
        }
        
        return result
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension String {
    func add(number: Int) -> String? {
        if let b = Int(self) {
            let newValue = b + number
            return "\(newValue)"
        }
        else {
            return nil
        }
    }
}

extension UIImage{
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
