//
//  MasterViewController.swift
//  word-scramble
//
//  Created by Renan Kosicki on 8/30/15.
//  Copyright (c) 2015 Renan Kosicki. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = [String]()
    var allWords = [String]()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        retrieveWordsFromFile()
        startGame()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
    }
    
    func retrieveWordsFromFile() {
        if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            if let startWords = NSString(contentsOfFile: startWordsPath, usedEncoding: nil, error: nil) {
                allWords = startWords.componentsSeparatedByString("\n") as! [String]
            }
        } else {
            allWords = ["silkworm"]
        }
    }
    
    func startGame() {
        allWords.shuffle()
        title = allWords[0]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    
    func promptForAnswer() {
        let activityController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
        activityController.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { [unowned self, activityController] (action: UIAlertAction!) in
            let answer = activityController.textFields![0] as! UITextField
            self.submitAnswer(answer.text)
        }
        
        activityController.addAction(submitAction)
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String) {
        let lowerAnswer = answer.lowercaseString
        
        if wordIsPossible(lowerAnswer) {
            if wordIsOriginal(lowerAnswer) {
                if wordIsReal(lowerAnswer) {
                    objects.insert(answer, atIndex: 0)
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    
    func wordIsPossible(word: String) -> Bool {
        return true
    }
    
    func wordIsOriginal(word: String) -> Bool {
        return true
    }
    
    func wordIsReal(word: String) -> Bool {
        return true
    }
    
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        
        return cell
    }
}

