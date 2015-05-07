
import UIKit
import MediaPlayer
import AVFoundation

protocol KSAVAudioRecorderDelegate: NSObjectProtocol{
    func failRecord(failedStr: String)
    func endConvertWithData(voiceData: NSData,voiceTime: Int16)
}

class KSAVAudioRecorder {
    var delegate: KSAVAudioRecorderDelegate
    var recorder: AVAudioRecorder?
    var soundFilePath = String()
    
    init(delegate: KSAVAudioRecorderDelegate){
        self.delegate = delegate
        AVAudioSession.sharedInstance().requestRecordPermission(){ granted in
            if granted {
                var error: NSError?
                if !AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
                    println("could not set session category")
                    if let e = error {
                        println(e.localizedDescription)
                    }
                }
                if !AVAudioSession.sharedInstance().setActive(true, error: &error) {
                    println("could not make session active")
                    if let e = error {
                        println(e.localizedDescription)
                    }
                }
            }else {
                var alertView = UIAlertView(title: "提示", message: "当前无法访问您的麦克风，请检查设置", delegate: self, cancelButtonTitle: "好")
                alertView.show()
            }
        }
    }
    
    func startRecord(){//进入录音接口...
        self.recorder = nil
        //设置录音文件的存储路径
        self.soundFilePath = self.storePath()
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(self.soundFilePath) {
            // probably won't happen. want to do something about it?
            println("sound exists")
        }
        var recordSettings = [
            //录音格式 无法使用`
            AVFormatIDKey: kAudioFormatLinearPCM,//kAudioFormatAppleLossless,
            //通道数
            AVNumberOfChannelsKey: 2,
            //采样率
            AVSampleRateKey : 11025.0,//44100.0
            AVLinearPCMBitDepthKey: 16,
            //音频质量,采样质量
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue
            ] as [NSObject : AnyObject]
        var error: NSError?
        self.recorder = AVAudioRecorder(URL: NSURL(fileURLWithPath: self.soundFilePath), settings: recordSettings, error: &error)
        if let e = error {
            println(e.localizedDescription)
        } else {
            self.recorder!.meteringEnabled = true
        }
        
        self.recorder!.record()//开始录音------------
    }
    
    func stopRecord() {//停止录音
        println("stop")
        if recorder != nil{
            var cTime = self.recorder!.currentTime
            recorder!.stop()
            recorder = nil
            if cTime >= 1{//判断录音时间是否大于1秒...
                let session = AVAudioSession.sharedInstance()
                var error: NSError?
                if !session.setActive(false, error: &error) {
                    println("could not make session inactive")
                    if let e = error {
                        println(e.localizedDescription)
                        return
                    }
                }
                self.delegate.endConvertWithData(NSData(contentsOfFile: self.soundFilePath)!, voiceTime: Int16(cTime))
            }else{
                self.deleteCurRecording(self.soundFilePath)
                self.delegate.failRecord("太短啦")
            }
        }
    }
    func cancelRecord() {//取消录音
        if recorder != nil {
            recorder!.stop()
            recorder = nil
            self.deleteCurRecording(self.soundFilePath)
        }
    }
    
    func storePath() -> String{
        return NSTemporaryDirectory().stringByAppendingPathComponent("recording-\(NSDate().toString(format: .ISO8601))")
    }
    
    func deleteCurRecording(curPath: String){
        var docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var fileManager = NSFileManager.defaultManager()
        var error: NSError?
        var files = fileManager.contentsOfDirectoryAtPath(docsDir, error: &error) as! [String]
        if let e = error {
            println(e.localizedDescription)
        }
        
        println("removing \(curPath)")
        if !fileManager.removeItemAtPath(curPath, error: &error) {
            NSLog("could not remove \(curPath)")
        }
        if let e = error {
            println(e.localizedDescription)
        }
    }
    
    func deleteAllRecordings() {//--删除所有录音文件
        var docsDir =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var fileManager = NSFileManager.defaultManager()
        var error: NSError?
        var files = fileManager.contentsOfDirectoryAtPath(docsDir, error: &error) as! [String]
        if let e = error {
            println(e.localizedDescription)
        }
        var recordings = files.filter( { (name: String) -> Bool in
            return name.hasPrefix("recording-")//name.hasSuffix("mp3")
        })
        for var i = 0; i < recordings.count; i++ {
            var path = docsDir + "/" + recordings[i]
            
            println("removing \(path)")
            if !fileManager.removeItemAtPath(path, error: &error) {
                NSLog("could not remove \(path)")
            }
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
}
