//
//  InfoVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 07.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit
import MessageUI

class InfoVC: UIViewController {
    
    @IBAction func clickContactPerEmail(_ sender: Any) {
        
        guard (MFMailComposeViewController.canSendMail()) else {
            let alert = UIAlertController(title: "contact.error.title".localized,
                                          message: "contact.error.message".localized,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return;
        }
        
        let emailController = MFMailComposeViewController()
        emailController.setSubject("\(Bundle.main.object(forInfoDictionaryKey: String(kCFBundleNameKey))!)")
        emailController.setToRecipients(["zajoapp@bluewin.ch"])
        emailController.mailComposeDelegate = self
        
        present(emailController, animated: true, completion: nil)
    }
}

extension InfoVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
