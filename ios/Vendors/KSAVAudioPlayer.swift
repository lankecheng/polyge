import UIKit
import AVFoundation
import MediaPlayer
protocol KSAVAudioPlayerDelegate: NSObjectProtocol{
    func KSAVAudioPlayerBeiginLoadVoice()
    func KSAVAudioPlayerBeiginPlay()
    func KSAVAudioPlayerDidFinishPlay()
}
class KSAVAudioPlayer: NSObject, AVAudioPlayerDelegate{
    var delegate:KSAVAudioPlayerDelegate?
    var player: AVAudioPlayer?
    static let sharedInstance = KSAVAudioPlayer()
  
    func playSongWithString(songUrl:NSString){//播放网络音频文件
        println("playSongWithString-----sss--------->>")
        dispatch_async(dispatch_queue_create("dfsfe", nil)){
            self.delegate?.KSAVAudioPlayerBeiginLoadVoice()
            var data = NSData(contentsOfURL: NSURL(string: songUrl as String)!)
            dispatch_async(dispatch_get_main_queue()){
                self.playSongWithData(data!)
            }
        }
    }
    
    func playSongWithUrl(songUrl:NSURL){//播放本地沙盒的音频文件
        println("playSongWithURL-----sss--------->>")
        dispatch_async(dispatch_queue_create("dfsfe", nil)){
            self.delegate?.KSAVAudioPlayerBeiginLoadVoice()
            if let data = NSData(contentsOfFile: songUrl.path!){
                dispatch_async(dispatch_get_main_queue()){
                    self.playSongWithData(data)
                }
            }else{
                println("当前音频文件不存在....")
            }
        }
    }

    func playSongWithData(songData:NSData){
        println("playSongWithData------->>>")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: UIApplication.sharedApplication())
        if self.player != nil{
            self.player!.stop()
            self.player!.delegate = nil
            self.player = nil
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("VoicePlayHasInterrupt", object: nil)
        var playerError: NSError?
        self.player = AVAudioPlayer(data: songData, error: &playerError)
        self.player!.volume = 1.0
        if self.player == nil{
            println("Error creating player: \(playerError?.description)")
        }else{
             AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
            self.player!.delegate = self
            self.player!.play()
            self.delegate?.KSAVAudioPlayerBeiginPlay()
        }
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.delegate?.KSAVAudioPlayerDidFinishPlay()
    }
    func stopSound(){
        if player != nil && player!.playing {
            player!.stop()
        }
    }

    func applicationWillResignActive(application: UIApplication){
        self.delegate?.KSAVAudioPlayerDidFinishPlay()
    }
}
