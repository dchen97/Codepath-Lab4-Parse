//
//  ChatViewController.swift
//  Codepath-lab4-parse
//
//  Created by Diana C on 2/21/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [String] = []
    var users: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.refreshData), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message View Cell") as! MessageViewCell
        
        cell.messageLabel.text = messages[indexPath.row]
        cell.userLabel.text = users[indexPath.row]
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSend(_ sender: Any) {
        if (messageTextField.text?.isEmpty)! {
            return;
        }
        let message = messageTextField.text
        let messageObj = PFObject(className: "Message")
        messageObj["text"] = message
        messageObj["user"] = PFUser.current()!
        
        messageObj.saveInBackground { (success: Bool, error: Error?) -> Void in
            if (success) {
                print("Success sending message")
                self.messageTextField.text = ""
            } else {
                print("Error sending message")
            }
        }
    }
    
    func refreshData() {
        self.messages = []
        self.users = []
        let query = PFQuery(className: "Message")
        query.includeKeys(["text", "user"])
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if let objects = objects {
                for object in objects {
                    let message = object
                    self.messages.append(message["text"] as! String)
                    var userName = ""
                    if message["user"] != nil {
                        let user = message["user"] as! PFUser
                        userName = user.object(forKey: "username") as! String
                    }
                    self.users.append(userName)
                }
                self.tableView.reloadData()
            } else {
                print("Error retrieving queries")
            }
        }
    }

}
