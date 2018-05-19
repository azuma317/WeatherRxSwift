//
//  UIViewController+presentError.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentError() {
        let alertController = UIAlertController(title: Text.Dialogues.errorTitle, message: Text.Dialogues.errorMessage, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: Text.Dialogues.okayText, style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
}
