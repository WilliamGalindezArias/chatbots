//
//  secondScreen.swift
//  bankApp2
//
//  Created by galwi05 on 19/09/2018.
//  Copyright © 2018 galwi05. All rights reserved.
//

import UIKit
import MASFoundation
import MASUI
import ApiAI
import AVFoundation


class secondScreen: UIViewController {

    // OUTLETS
    @IBOutlet weak var displayMessageBox: UITextView!
    
    
    @IBOutlet weak var siriusResponse: UILabel!
    
    @IBOutlet weak var messageField: UITextField!
    // * Outlets
    
    // Functions
    @IBAction func invokeChatMessages(_ sender: UIButton) {
     print("Invoke API button is clicked")
        
    MAS.getFrom("/protected/resource/products", withParameters: ["operation":"listProducts"], andHeaders: nil){
            (response, error) in
                print(" the response was : \(describing: response?.debugDescription)")
                self.displayMessageBox.text = response?.debugDescription
        }
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageField.text, text != "" {
            request?.query = text
        } else {
            return
        }
        // response
        var amount: float3
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
                print(textResponse)
                var textResponded: String
                textResponded = textResponse
                if textResponded == "Here's your latest balance:"{
                    print("here is the balance")
                    MAS.getFrom("/balance", withParameters: ["operation":"savings"], andHeaders: nil, request: .json, responseType: .textPlain, completion: { (response, error) in
                        print(" the response was : \(describing: response?.debugDescription)")
                        
                        let balance = response!["MASResponseInfoBodyInfoKey"]
                        self.displayMessageBox.text = " \(balance!)"
                    })
                }
                if textResponded == "All right. So, you're transferring 30 USD from your savings account to a savings account. Is that right?"{
                    var urlTextEndPoint: String
                    urlTextEndPoint = "/mws-team1/exercise4?in=101"
                    print("here call API for OTP")
                    MAS.setWillHandleOTPAuthentication(true)
                    MAS.setGatewayNetworkActivityLogging(true)
                    
                    let builder = MASRequestBuilder.init(httpMethod: "GET")
                    builder.endPoint = urlTextEndPoint
                    builder.isPublic = false
                    MAS.invoke(builder.build()!) { (httpresponse, response, error) in
                    }
                }
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        messageField.text = ""
    }
    
    
    
    
   
    
    @IBAction func performLogOut(_ sender: UIButton) {
        MASUser.current()?.logout(true, completion: { (completed, error) in
            if completed {
                print("user logged out")
            }
        })
        
    }
    // Line added #1
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.siriusResponse.text = text
        }, completion: nil)
    }
    // object validations
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    
    
    
    
}
