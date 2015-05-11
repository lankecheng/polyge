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
  
    func playSongWithData(songData:NSData){
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
            NSLog("Error creating player: \(playerError?.description)")
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
