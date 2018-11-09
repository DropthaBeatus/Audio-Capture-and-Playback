//
//  AudioCaptureViewController.swift
//  Audio Capture and Playback
//
//  Created by Liam Flaherty on 11/7/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//

import UIKit
import AVKit

class AudioCaptureViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordBTN: UIBarButtonItem!
    
    @IBOutlet weak var playBTN: UIBarButtonItem!
    
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    
    var playAudioURL : URL?
    
    var recordOn = false
    var pauseOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordBTN.isEnabled = false
        self.playBTN.isEnabled = false
        recordBTN.addTargetForAction(target: self, action: #selector(record))
        playBTN.addTargetForAction(target: self, action: #selector(play))
        audioSession = AVAudioSession.sharedInstance()
        self.loadAll()
    }
    
    func loadLastAudioFile(){
         playAudioURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let fileManager = FileManager.default
        let filepath = playAudioURL?.path
        if fileManager.fileExists(atPath: filepath!) {
            self.playBTN.isEnabled = true
        }
    }
    
    func loadAll(){
        do{
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission() {_ in
                self.audioSession.requestRecordPermission() { [unowned self] allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            self.loadLastAudioFile()
                            self.recordBTN.isEnabled = true
                        } else {
                            // don't let the app record because permission was denied
                        }
                    }
                }
            }
        } catch {
            print("Error: Could not allow recording")
        }
        
    }
    
    
    @objc func record (sender:UIButton) {
        if(!recordOn){
            startRecording()
            recordBTN.image = UIImage(named : "stop")
            recordOn = true
        }
        else{
            recordBTN.image = UIImage(named : "record")
            finishRecording(success: true)
            recordOn = false
        }
    }
    
    @objc func play(sender:UIButton) {
        if(!pauseOn){
            audioPlayer?.play()
            playBTN.image = UIImage(named: "stop")
            pauseOn = true
        }
        else{
            audioPlayer?.pause()
            playBTN.image = UIImage(named: "play")
            pauseOn = false
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        playAudioURL = audioFilename
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self as AVAudioRecorderDelegate
            audioRecorder.record()
            playAudioURL = audioFilename
           // recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
 
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Recorded Successfully: Now to save files stuff")
            do{
            audioPlayer = try AVAudioPlayer(contentsOf: playAudioURL!)
            self.playBTN.isEnabled = true
            }catch{
                print("Could not load audio player")
            }
            
        } else {
            print("Recorded Nothing!!!!!!!!")
        }
    }
    

    

}
