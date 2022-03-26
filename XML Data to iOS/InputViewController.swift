//
//  InputViewController.swift
//  XML Data to iOS
//
//  Created by Ayush Singh on 26/03/22.
//

import UIKit

class InputViewController: UIViewController {

    
    let textView = UITextView()
    let myFirstButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display()
            

        }

        @objc func pressed() {
            if textView.text != "" {
                url = textView.text
                
                self.performSegue(withIdentifier: "next", sender: self)

                
                
            }
        }

    
    func display() {
        //Text view
        textView.frame = CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0)
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.center = self.view.center
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.lightGray
        view.addSubview(textView)
        
        //Button
        
        myFirstButton.setTitle("Submit", for: .normal)
        myFirstButton.setTitleColor(.black, for: .normal)
        myFirstButton.backgroundColor = .cyan
        myFirstButton.center = self.view.center
        
        myFirstButton.frame = CGRect(x: 15, y: 50, width: view.frame.width, height: 50)
        myFirstButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        myFirstButton.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - myFirstButton.frame.size.height - 20)
        
        view.addSubview(myFirstButton)
    }
    


}
