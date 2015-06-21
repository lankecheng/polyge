
import UIKit
import MediaPlayer
import AVFoundation

protocol KSAVAudioRecorderDelegate: NSObjectProtocol{
    func failRecord(failedStr: String)
    func endConvertWithData(voiceData: NSData,voiceTime: Int16)
}

class KSAVAudioRecorder {
    var delegate: KSAVAudioRecorderDelegate
    var recorder: AVAudioRecorder!
    var soundFilePath = String()
    
    init(delegate: KSAVAudioRecorderDelegate){
        self.delegate = delegate
        AVAudioSession.sharedInstance().requestRecordPermission(){ granted in
            if granted {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                } catch let error as NSError {
                        NSLog(error.localizedDescription)
                } catch {
                    fatalError()
                }
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch let error as NSError {
                        NSLog(error.localizedDescription)
                } catch {
                    fatalError()
                }
            }else {
                let alertView = UIAlertView(title: "提示", message: "当前无法访问您的麦克风，请检查设置", delegate: self, cancelButtonTitle: "好")
                alertView.show()
            }
        }
    }
    
    func startRecord(){//进入录音接口...
        //设置录音文件的存储路径
        self.soundFilePath = self.storePath()
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(self.soundFilePath) {
            do{
                try filemanager.removeItemAtPath(self.soundFilePath)
            }catch{
                
            }
        }
        let settings = [
            //录音格式 无法使用`
            AVFormatIDKey: Int(kAudioFormatLinearPCM),//kAudioFormatAppleLossless,
            //通道数
            AVNumberOfChannelsKey: 2 as NSNumber,
            //采样率
            AVSampleRateKey : 11025.0,//44100.0
            AVLinearPCMBitDepthKey: 16,
            //音频质量,采样质量
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue

        ]
        do {
            self.recorder = try AVAudioRecorder(URL: NSURL(fileURLWithPath: self.soundFilePath), settings: settings)
            self.recorder.record()
        } catch let error as NSError {
            NSLog(error.localizedDescription)
        }
    }
    
    func stopRecord() {//停止录音
            let cTime = self.recorder.currentTime
            recorder.stop()
            if cTime >= 1{//判断录音时间是否大于1秒...
                let session = AVAudioSession.sharedInstance()
                do {
                    try session.setActive(false)
                } catch let error as NSError {
                    NSLog(error.localizedDescription)
                    return
                }
                self.delegate.endConvertWithData(NSData(contentsOfFile: self.soundFilePath)!, voiceTime: Int16(cTime))
                self.deleteCurRecording(self.soundFilePath)
            }else{
                self.deleteCurRecording(self.soundFilePath)
                self.delegate.failRecord("太短啦")
            }
    }
    func cancelRecord() {//取消录音
            recorder.stop()
            self.deleteCurRecording(self.soundFilePath)
    }
    
    func storePath() -> String{
        return NSTemporaryDirectory().stringByAppendingPathComponent("recording-\(NSDate().toString(format: .ISO8601))")
    }
    
    func deleteCurRecording(curPath: String){
        do {
            try NSFileManager.defaultManager().removeItemAtPath(curPath)
        } catch let error as NSError {
            NSLog("could not remove \(curPath) \(error.localizedDescription)")
        }
    }
    
}
