//
//  InfoVC.swift
//  MonPain
//
//  Created by Jonathan Duss on 07.06.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import UIKit
import MessageUI

class SettingsVC: UITableViewController {
    
    @IBOutlet weak var saltRelationControl: UISegmentedControl!
    
    
    private let headers = [
        "settings.ingredients-parameters.header",
        "settings.contact.header"
    ]
    
    private let footers = [
        "settings.ingredients-parameters.footer",
        "settings.contact.footer"
    ]
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "settings.screen-title".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saltRelationControl.selectedSegmentIndex = UserPreferences.shared.saltRelation.rawValue
    }
    
    @IBAction func saltRelationChanged(_ sender: Any) {
        UserPreferences.shared.saltRelation = SaltRelation(rawValue: saltRelationControl.selectedSegmentIndex) ?? .water
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section].localized
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footers[section].localized
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            contactPerEmail()
            break
        default:
            break
        }
    }
}

extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func contactPerEmail() {
        
        guard (MFMailComposeViewController.canSendMail()) else {
            let alert = UIAlertController(title: "settings.contact.error.title".localized,
                                          message: "settings.contact.error.message".localized,
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
