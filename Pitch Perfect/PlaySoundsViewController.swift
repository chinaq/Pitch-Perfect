//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by 强忠华 on 15/2/14.
//  Copyright (c) 2015年 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var recordedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //播放硬编码的mp3文件
//        if var filepath = NSBundle.mainBundle().pathForResource("movie_quote", ofType:"mp3"){  //设置文件
//            var filePathUrl = NSURL.fileURLWithPath(filepath) //转成url
//            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)  //设置url到audioPlayer
//            audioPlayer.enableRate = true  //设置播放速度可变
//        }else{
//            println("not found the mp3 file")
//        }
        
        //设置改变速度的录音文件
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl
            , error: nil)  //设置url到audioPlayer
        audioPlayer.enableRate = true  //设置播放速度可变
        
        //设置改变音高的录音文件
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //////////////按速度播放//////////////////
    
    @IBAction func playSlowly(sender: UIButton) {
        playBy(0.5)
    }
    

    @IBAction func playFast(sender: UIButton) {
        playBy(1.5)
    }
    
    
    //按速度播放
    private func playBy(speed:Float){
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    
    
    ////////////////按音高播放/////////////
    
    @IBAction func playLikeChipmuck(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playLikeDarthvader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    //按音高播放
    private func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)   //将player添加到engine上
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)  //将pitch添加到engine上
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)  //将player连接到pitch中
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)  //将pitch连接到输出流中
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)  //设置player的播放文件
        audioEngine.startAndReturnError(nil)  //engine准备启动
        
        audioPlayerNode.play()  //player开始播放
    }
    
    
    
    ///////////////停止播放////////////////
    
    @IBAction func stop(sender: UIButton) {
        audioPlayer.stop()
    }
    
    
    

    
    

    
}
