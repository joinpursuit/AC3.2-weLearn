//
//  CustomAlert.swift
//  Graffy
//
//  Created by Marty Avedon on 2/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//
import Foundation
import JSSAlertView

func showAlert(_ message: String, presentOn: UIViewController) {
    let alertview = JSSAlertView().show(presentOn,
                                        title: message.uppercased(),
                                        buttonText: "Ok, fine".uppercased(),
                                        color: UIColor.weLearnBrightBlue)
    
    alertview.setTitleFont("Avenir-Black")
    alertview.setTextTheme(.light) // can be .light or .dark
    alertview.setButtonFont("Avenir-Medium")
}
