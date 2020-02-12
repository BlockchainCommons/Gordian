//
//  PageViewController.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

    var titleLabel = UILabel()
    var textView = UITextView()
    var page: Pages
    var donationLinkUrl = "https://btcpay.blockchaincommons.com"
    var homePageUrl = "www.blockchaincommons.com"
    var repoLink = "https://github.com/BlockchainCommons/Bitcoin-Standup"
    var standupAppLink = "https://drive.google.com/open?id=1lXyl_zO6WPJN5tzWAVV3p42WPFtyesCR"
    var scriptLink = "https://github.com/BlockchainCommons/Bitcoin-Standup/tree/master/Scripts"
    
    init(with page: Pages) {
        self.page = page
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
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
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.addHyperLinksToText(originalText: page.body, hyperLinks: ["here": donationLinkUrl, "blockchaincommons.com": homePageUrl, "GitHub": repoLink, "StandUp.app": standupAppLink, "StandUp.sh": scriptLink])

        self.view.addSubview(textView)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == donationLinkUrl) || (URL.absoluteString == homePageUrl) || (URL.absoluteString == repoLink) {
            UIApplication.shared.open(URL) { (Bool) in

            }
        }
        return false
    }

}

extension UITextView {

  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .left
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13), range: fullRange)
        attributedOriginalText.addAttribute(.foregroundColor, value: UIColor.lightGray, range: fullRange)
    }

    self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
    ]
    self.attributedText = attributedOriginalText
  }
}
