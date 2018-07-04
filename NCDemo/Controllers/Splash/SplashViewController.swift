//
//  SplashViewController.swift
//  NCDemo
//
//  Created by Vivek Gupta on 28/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        
    }
    
    func showFirstTabBarScreen(){
        spinner.stopAnimating()
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: StoryBoard.FirstTabBar.Identifier, bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: StoryBoard.FirstTabBar.Identifier)
            AppDelegate.sharedInstance.window?.rootViewController = viewC
            AppDelegate.sharedInstance.window?.makeKeyAndVisible()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
