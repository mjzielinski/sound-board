//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Michael Zielinski on 3/27/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
//* need to record sound
import AVFoundation

class SoundViewController: UIViewController, UITextFieldDelegate {
    
    //* outlet to record button
    @IBOutlet weak var recordButton: UIButton!
    
    //* outlet to play button
    @IBOutlet weak var playButton: UIButton!
    
    //* outet to add button
    @IBOutlet weak var addButton: UIButton!
    
    //* outlet to name text field
    @IBOutlet weak var nameTextField: UITextField!
    
    //* set up audio recorder object
    var audioRecorder : AVAudioRecorder?
    
    //* set up audio player object
    var audioPlayer : AVAudioPlayer?
    
    //* variable holds audio url
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* initially have play and add buttons disabled
        playButton.isEnabled = false
        addButton.isEnabled = false
        
        //* set up text field delegate (needed for keyboard actions)
        nameTextField.delegate = self
        
        //* to dismiss keyboard when click outside of it
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SoundViewController.dismissKeyboard)))
        
        //* call function to set up the recorder
        setupRecorder()
    }
    
    //* set up the audio recorder
    func setupRecorder() {
        do {
            //* create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //* create url for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)
            
            //* create settings for the audio recorder
            var settings : [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            //* create audio recorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch {}
    }
    
    //* outlet for action when record is tapped
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            //* stop the recording
            audioRecorder!.stop()
            //* change button title to Record
            recordButton.setTitle("Record", for: .normal)
            //* re enable play and add buttons
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            //* start the recording
            audioRecorder!.record()
            //* change the button title to Stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    //* outlet for action when play is tapped
    @IBAction func playTapped(_ sender: Any) {
        do {
            //* plays the audio
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {}
    }
    
    //* outlet for action when add is tapped
    @IBAction func addTapped(_ sender: Any) {
        
        //*set up context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //* create the sound object
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        //* save the sound object
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //* pop back view controller
        navigationController!.popViewController(animated: true)
    }
    
    //* disappear the keyboard when click anywhere
    func dismissKeyboard() {
        nameTextField.resignFirstResponder()
    }
    
    //* disappear the keyboard when done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
}
