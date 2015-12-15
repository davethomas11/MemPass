//
//  OnBoardingPageViewController.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-13.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class OnBoardingPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    private var pageViewController = UIPageViewController()
    private var pages:[UIViewController] = [OnBoarding1ViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ob2 = createOnBoarding(text: "If you're like me you've got a couple good ones", pw1: "\"1337super1337PW$%^&\"")
        let ob3 = createOnBoarding(text: "But eventually you get lazy...", pw1: "\"happy123\"")
        let ob4 = createOnBoarding(text: "Because your memory is the best place", pw1: "\"dt115789\"")
        let ob5 = createOnBoarding(text: "Not some database or password manager", pw1: "\"dogsbreakfast500^\"")
        let ob6 = createOnBoarding(text: "What if your simple passwords could be stronger?", pw1: "\"d0gsbr%ast500$%&*^$*^\"")
        let ob7 = createOnBoarding(text: "And you could remember them?", pw1: "\"d0gsbr4354st50$^*^\"")
        let ob8 = createOnBoarding(text: "MemPass is your answer.", pw1:"\"to you & your device!", pw2:"\"unique passwords\"", pw3: "\"mempass generates\"")

        
        pages.append(ob2)
        pages.append(ob3)
        pages.append(ob4)
        pages.append(ob5)
        pages.append(ob6)
        pages.append(ob7)
        pages.append(ob8)

        // Do any additional setup after loading the view.
        
        
        pageViewController.setViewControllers([pages.first!],
            direction:UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createOnBoarding(text text:String, pw1:String, pw2:String="", pw3:String="") -> OnBoarding1ViewController {
        
        let onBoarding2 = OnBoarding1ViewController()

        onBoarding2.__pw2 = pw2
        onBoarding2.__pw3 = pw3
        onBoarding2.__pw1 = pw1
        onBoarding2.__text = text
        
        return onBoarding2
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    
    /// UIPageViewControllerDataSource implementation
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let found = pages.indexOf(viewController) where found > 0 {
            let page = pages[found - 1]
            return page
        }
        return nil
    }
    
    /// UIPageViewControllerDataSource implementation
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let found = pages.indexOf(viewController) where found + 1 < pages.count {
            let page = pages[found + 1]
            return page
        }
        return nil
    }
    
    /// The number of items reflected in the page
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func next() {
        
        
        if let vc = pageViewController.viewControllers?.first, let found = pages.indexOf(vc) where found >= 0 && found < pages.count-1 {
            pageViewController.setViewControllers([pages[found+1]],
                direction:UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
    }
}
