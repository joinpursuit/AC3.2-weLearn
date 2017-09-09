//
//  CustomAlert.swift
//  Graffy
//
//  Created by Marty Avedon on 2/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//
import Foundation
import JSSAlertView
import SnapKit

enum ErrorStatus {
    case passwordFail
    case usernameFail
    case linkFail
}

class CustomAlert: UIViewController {
    
    static func tellThem(_ status: ErrorStatus) -> String {
        switch status {
        case .passwordFail:
            return "The password you typed is incorrect."
        case .usernameFail:
            return "The username you typed is incorrect."
        case .linkFail:
            return "We can't view the link right now."
        }
    }
    
    var titleFont = "Avenir-Light"
    var textFont = "Avenir-Medium"
    
    var backgroundColor = UIColor.weLearnBlue
    var textColor = UIColor.weLearnCoolWhite
    
    // refitting JSSAlert code to fit our needs
    
    var containerView: UIView!
    var alertBackgroundView: UIView!
    var titleLabel: UILabel!
    var textView: UITextView!
    weak var rootViewController: UIViewController! // has to be weak, for memory
    var progressBar: UIProgressView!
    var closeAction: (()-> Void)!
    var cancelAction: (() -> Void)!
    var isAlertOpen: Bool = false
    
    enum ActionType {
        case close, cancel
    }
    
    let baseHeight: CGFloat = 160.0
    var alertWidth: CGFloat = 290.0
    let padding: CGFloat = 20.0
    
    var viewWidth: CGFloat?
    var viewHeight: CGFloat?
    
    // gets controller's size for properly sizing alert
    
    func rootViewControllerSize() -> CGSize {
        let size = rootViewController.view.frame.size
        
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            
            return CGSize(width: size.height, height: size.width)
        }
        
        return size
    }
    
    // gets screen's size for properly sizing alert
    
    func screenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            
            return CGSize(width: screenSize.height, height: screenSize.width)
        }
        
        return screenSize
    }
    
    // inits taken from JSSAlert wholesale
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // makes all the stuff inside the alert
    
    open override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let size = self.rootViewControllerSize()
        
        self.viewWidth = size.width
        self.viewHeight = size.height
        
        var yPos: CGFloat = 0.0
        let contentWidth:CGFloat = self.alertWidth - (self.padding*2)
        
        // position the title
        
        let titleString = titleLabel.text! as NSString
        let titleAttr = [NSFontAttributeName: titleLabel.font!]
        let titleSize = CGSize(width: contentWidth, height: 90)
        let titleRect = titleString.boundingRect(with: titleSize, options: .usesLineFragmentOrigin, attributes: titleAttr, context: nil)
        
        yPos = padding
        titleLabel.frame = CGRect(x: padding, y: yPos, width: alertWidth - (padding * 2), height: ceil(titleRect.height))
        yPos += ceil(titleRect.height)
        
        // position the progressBar image view, if there is one
        
        if self.progressBar != nil {
            yPos = (padding * 2)  + progressBar.frame.height
            
            let centerX = (self.alertWidth-self.progressBar.frame.width)/2
            
            self.progressBar.frame.origin = CGPoint(x: centerX, y: self.padding * 3)
            yPos += padding * 2
        }
        
        // position text
        
        if self.textView != nil {
            let textString = textView.text! as NSString
            let textAttr = [NSFontAttributeName: textView.font!]
            let realSize = textView.sizeThatFits(CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude))
            let textSize = CGSize(width: contentWidth, height: CGFloat(fmaxf(Float(90.0), Float(realSize.height))))
            let textRect = textString.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: textAttr, context: nil)
            
            textView.frame = CGRect(x: padding, y: yPos, width: alertWidth - (padding * 2), height: ceil(textRect.height) * 2)
            
            yPos += ceil(textRect.height) + padding / 2
        }
        
        // size the background view
        
        alertBackgroundView.frame = CGRect(x: 0, y: 0, width: alertWidth, height: yPos)
        
        // size the container that holds everything together
        
        containerView.frame = CGRect(x: (viewWidth! - alertWidth) / 2, y: (viewHeight! - yPos)/2, width: alertWidth, height: yPos)
    }
    
    func updateMessage(_ message: String) {
        // relayout to account for size changes
        self.viewDidLayoutSubviews()
    }
    
    // MARK: - Main Show Method
    
    /// Main method for rendering JSSAlertViewController
    ///
    ///
    /// - Parameters:
    ///   - viewController: ViewController above which JSSAlertView will be shown
    ///   - title: JSSAlertView title
    ///   - text: JSSAlertView text
    ///   - noButtons: Option for no buttons, ehen activated, it gets closed by tap
    ///   - buttonText: Button text
    ///   - cancelButtonText: Cancel button text
    ///   - color: JSSAlertView color
    ///   - iconImage: Image which gets placed above title
    ///   - delay: Delay after which JSSAlertView automatically disapears
    ///   - timeLeft: Counter aka Tinder counter shows time in seconds
    /// - Returns: returns JSSAlertViewResponder
    
    @discardableResult
    
    func show(_ viewController: UIViewController,
              title: String,
              text: String? = nil,
              addProgressBar: Bool = false
        ) -> TotallyNotJSSResponder {
        
        rootViewController = viewController
        
        view.backgroundColor = UIColor.weLearnBlack
        
        let baseColor = backgroundColor
        let textColor = self.textColor
        
        let sz = screenSize()
        
        viewWidth = sz.width
        viewHeight = sz.height
        
        view.frame.size = sz
        
        // Container for the entire alert modal contents
        
        containerView = UIView()
        view.addSubview(containerView!)
        
        // Background view/main color
        
        alertBackgroundView = UIView()
        alertBackgroundView.backgroundColor = baseColor
        alertBackgroundView.layer.cornerRadius = 20
        alertBackgroundView.layer.masksToBounds = true
        
        containerView.addSubview(alertBackgroundView!)
        
        // Progress Bar
        
        self.progressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        
        if addProgressBar {
            progressBar?.progressTintColor = UIColor.weLearnLightBlue
            progressBar?.trackTintColor = UIColor.weLearnBlue
            
            containerView.addSubview(progressBar!)
        }
        
        // Title
        
        titleLabel = UILabel()
        titleLabel.textColor = textColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: self.titleFont, size: 36)
        titleLabel.text = title.uppercased()
        
        containerView.addSubview(titleLabel)
        
        // View text
        
        if let text = text {
            textView = UITextView()
            textView.isUserInteractionEnabled = false
            textView.isEditable = false
            textView.textColor = textColor
            textView.textAlignment = .center
            textView.font = UIFont(name: self.textFont, size: 16)
            textView.backgroundColor = UIColor.clear
            textView.text = text
            containerView.addSubview(textView)
        }
        /*
         // Button
         self.noButtons = true
         if !noButtons {
         self.noButtons = false
         dismissButton = UIButton()
         let buttonColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.8))
         let buttonHighlightColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.9))
         dismissButton.setBackgroundImage(buttonColor, for: .normal)
         dismissButton.setBackgroundImage(buttonHighlightColor, for: .highlighted)
         dismissButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
         alertBackgroundView!.addSubview(dismissButton)
         // Button text
         buttonLabel = UILabel()
         buttonLabel.textColor = textColor
         buttonLabel.numberOfLines = 1
         buttonLabel.textAlignment = .center
         if let text = buttonText {
         buttonLabel.text = text
         } else {
         buttonLabel.text = "OK"
         }
         dismissButton.addSubview(buttonLabel)
         
         // Second cancel button
         if cancelButtonText != nil {
         cancelButton = UIButton()
         let buttonColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.8))
         let buttonHighlightColor = UIImage.with(color: adjustBrightness(baseColor!, amount: 0.9))
         cancelButton.setBackgroundImage(buttonColor, for: .normal)
         cancelButton.setBackgroundImage(buttonHighlightColor, for: .highlighted)
         cancelButton.addTarget(self, action: #selector(JSSAlertView.cancelButtonTap), for: .touchUpInside)
         alertBackgroundView!.addSubview(cancelButton)
         // Button text
         cancelButtonLabel = UILabel()
         cancelButtonLabel.alpha = 0.7
         cancelButtonLabel.textColor = textColor
         cancelButtonLabel.numberOfLines = 1
         cancelButtonLabel.textAlignment = .center
         cancelButtonLabel.text = cancelButtonText
         
         cancelButton.addSubview(cancelButtonLabel)
         }
         }
         */
        
        // Animate it in
        
        view.alpha = 0
        
        definesPresentationContext = true
        modalPresentationStyle = .overFullScreen
        
        viewController.present(self, animated: false, completion: {
            // Animate it in
            
            UIView.animate(withDuration: 0.2) {
                self.view.alpha = 1
            }
            
            self.containerView.center.x = self.view.center.x
            self.containerView.center.y = -500
            
            UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                self.containerView.center = self.view.center
            }, completion: { finished in
                self.isAlertOpen = true
            })
        })
        
        return TotallyNotJSSResponder(alertview: self)
    }
    
    // Responder for user interaction
    
    class TotallyNotJSSResponder {
        let alertview: CustomAlert
        /// Contructor
        ///
        /// - Parameter alertview: constructs it self from JSSAlertView
        public init(alertview: CustomAlert) {
            self.alertview = alertview
        }
        
        /// Close action to remove from superview
        @objc func close() {
            self.alertview.closeView(false)
        }
    }
    
    // MARK: - Closing/Removing
    
    func removeView() {
        isAlertOpen = false
        
        removeFromParentViewController()
        view.removeFromSuperview()
    }
    
    func closeView(_ withCallback: Bool, source: ActionType = .close) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.containerView.center.y = self.view.center.y + self.viewHeight!
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                self.view.alpha = 0
            }, completion: { finished in
                self.dismiss(animated: false, completion: {
                    if withCallback {
                        if let action = self.closeAction , source == .close {
                            action()
                        } else if let action = self.cancelAction, source == .cancel {
                            action()
                        }
                    }
                })
            })
        })
    }
}

func showAlert(_ message: String, presentOn: UIViewController) {
    let alertview = JSSAlertView().show(presentOn,
                                        title: message.uppercased(),
                                        buttonText: "Ok, fine".uppercased(),
                                        color: UIColor.weLearnBlue)
    
    alertview.setTitleFont("Avenir-Light")
    alertview.setTextTheme(.light) // can be .light or .dark
    alertview.setButtonFont("Avenir-Black")
}
