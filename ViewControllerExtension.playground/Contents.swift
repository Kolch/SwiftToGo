import UIKit

extension UIViewController {
    
    // MARK: - ToolBar
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.hideKeyboard))
        toolBar.setItems([doneButton], animated: false)
        return toolBar
    }
    
    // MARK: - Activity Indicator
    func runActivityIndicator(){
        let indicatorView = UIActivityIndicatorView()
        indicatorView.startAnimating()
        indicatorView.style = .large
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.tag = 420
        self.view.addSubview(indicatorView)
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.view.isUserInteractionEnabled = false
    }
    
    func stopActivityIndicator(){
        if let subViews = self.view.viewWithTag(420) {
            subViews.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Keyboard Notifications
    func signUpForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // MARK: - Alert
    func showBasicAlert(title: String, text: String, completion: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let cancel = UIAlertAction(title:"Ок", style: .default)
        alertController.addAction(cancel)
        
        present(alertController, animated:true, completion: {
            guard let callback = completion else { return }
            DispatchQueue.main.async {
                callback()
            }
        })
    }
}

// MARK: - USAGE
class VC: UIViewController {
    override func viewDidLoad() {
        
        // MARK: ToolBar
        let textField = UITextField()
        textField.inputAccessoryView = getToolBar()
        
        
        // MARK: - Activity Indicator
        runActivityIndicator()
        stopActivityIndicator()
        
        
        // MARK: - Keyboard Notifications
        signUpForKeyboardNotifications()
        removeKeyboardNotifications()
        
        
        // MARK: - Alert
        showBasicAlert(title: "Alert", text: "message")
        
        // or
        showBasicAlert(title: "Aler", text: "message") {
            // completion action
        }
    }
}
