//
//  PageViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UINavigationControllerDelegate {

    var titleLabel = UILabel()
    var textView = UITextView()
    var page: Pages
    
    init(with page: Pages) {
        self.page = page
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        titleLabel = UILabel(frame: CGRect(x: 16, y: self.navigationController!.navigationBar.frame.maxY + 20, width: self.view.frame.width - 32, height: 21))
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .black)
        titleLabel.text = page.title
        titleLabel.sizeToFit()
        self.view.addSubview(titleLabel)
        
        textView.frame = CGRect(x:16, y:self.titleLabel.frame.maxY + 20, width: self.view.frame.width - 32, height: self.view.frame.height - (self.navigationController!.navigationBar.frame.height + self.titleLabel.frame.height + 80))
        textView.text = page.body
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(textView)
    }

}
