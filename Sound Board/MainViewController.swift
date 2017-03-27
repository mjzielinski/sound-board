//
//  MainViewController.swift
//  Sound Board
//
//  Created by Michael Zielinski on 3/27/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
//* needed for audio player
import AVFoundation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //* outlet to tableView
    @IBOutlet weak var tableView: UITableView!
    
    //* create audio player object
    var audioPlayer : AVAudioPlayer?
    
    //* create array of Sound objects
    var sounds : [Sound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* for table view data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //* when view will appear, fetch the sound objects and reload data
    override func viewWillAppear(_ animated: Bool) {
        //set up context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            sounds = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch {}
    }
    
    //* set number of table rows based on number of sound objects
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    //* put the contents in cells of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
    }
    
    //* when row is selected play the sound
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        do {
            audioPlayer = try AVAudioPlayer(data: sound.audio as! Data)
            audioPlayer?.play()
        } catch {}
        //* to deselect the row after click
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //* allow swipe delete for rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // set up context, get sound for index path row, delete it
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let sound = sounds[indexPath.row]
            context.delete(sound)
            
            // save after the delete
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // reload data
            do {
            sounds = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
            } catch {}
        }
    }
    
    
}

