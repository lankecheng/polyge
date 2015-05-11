
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
                    if let e = error {
                        NSLog(e.localizedDescription)
                    }
                }
                if !AVAudioSession.sharedInstance().setActive(true, error: &error) {
                    if let e = error {
                        NSLog(e.localizedDescription)
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
            NSLog(e.localizedDescription)
        } else {
            self.recorder!.meteringEnabled = true
        }
        
        self.recorder!.record()//开始录音------------
    }
    
    func stopRecord() {//停止录音
        if recorder != nil{
            var cTime = self.recorder!.currentTime
            recorder!.stop()
            recorder = nil
            if cTime >= 1{//判断录音时间是否大于1秒...
                let session = AVAudioSession.sharedInstance()
                var error: NSError?
                if !session.setActive(false, error: &error) {
                    if let e = error {
                        NSLog(e.localizedDescription)
                        return
                    }
                }
                self.delegate.endConvertWithData(NSData(contentsOfFile: self.soundFilePath)!, voiceTime: Int16(cTime))
                self.deleteCurRecording(self.soundFilePath)
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
        var error: NSError?
        if !NSFileManager.defaultManager().removeItemAtPath(curPath, error: &error) {
            NSLog("could not remove \(curPath) \(error?.localizedDescription)")
        }
    }
    
}
