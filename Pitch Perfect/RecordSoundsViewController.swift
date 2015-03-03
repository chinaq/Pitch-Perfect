//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by 强忠华 on 14/11/30.
//  Copyright (c) 2014年 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        showButtonToRecord()
    }
    

    //开始录音
    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        stopButton.hidden = false
        recordingInProgress.hidden = false
        
        recording()  //录音
    }

    
    //停止录音
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        recordingInProgress.hidden = true
    }
    
    
    //页面跳转前，传递数据
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController
                as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recordedAudio = data
        }
    }
    
    
    
    //完成录音后的代理动作
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            
            //存储录音名称和路径
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            //跳转页面
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        
        }else{
            println("Recording is not successful")
            showButtonToRecord()
        }
    }
    
    
    
    //录音
    private func recording(){
        //设置一个完整的文件保存路径和名称
        let dirPath = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true)[0] as String   //文件存储路径
        let currentDateTime = NSDate()  //取得当前时间
        let formatter = NSDateFormatter()  //日期格式化器
        formatter.dateFormat = "ddMMyyyy-HHmmss"  //设置格式化样式
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"  //设置保存文件名为日期
        let pathArray = [dirPath, recordingName]  //路径、文件名放入数组
        let filePath = NSURL.fileURLWithPathComponents(pathArray)  //合成完整路径文件名
        println(filePath)
        
        //设置session
        var session = AVAudioSession.sharedInstance()  //获取session（猜测该session是一个单例模式）
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil) //此session可以录音和播放
        
        //设置audioRecord，并播放
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)  //路径放入录音器
        audioRecorder.delegate = self  //设置本类为audioRecorder的代理
        audioRecorder.meteringEnabled = true  //录音表开启（暂不明白）
        audioRecorder.record()  //录音开始，停止后内容会自动保存至之前设置的路径
    }
    
    private func showButtonToRecord(){
        recordButton.enabled = true
        stopButton.hidden = true
    }
}

