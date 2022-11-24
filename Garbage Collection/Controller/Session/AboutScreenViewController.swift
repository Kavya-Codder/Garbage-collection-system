//
//  AboutScreenViewController.swift
//  Garbage Collection
//
//  Created by Sunil Kumar on 04/09/2022.
//

import UIKit
import WebKit

class AboutScreenViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var AboutWebView: WKWebView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.youtube.com/embed/Xrdn8F3PWfk")
        AboutWebView.load(URLRequest(url: url!))
        AboutWebView.uiDelegate = self
        AboutWebView.navigationDelegate = self
        indicator.startAnimating()
        self.navigationController?.isNavigationBarHidden = true
     }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.imgCover.isHidden = true
            self.indicator.isHidden = true
        }
    }
   

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
