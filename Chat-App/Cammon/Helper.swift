//
//  Helper.swift
//  Chat-App
//
//  Created by Sabri Çetin on 8.01.2025.
//

import Foundation
import UIKit

class Helper {
    static func dialogMessage ( message: String , vc: UIViewController) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }
}
