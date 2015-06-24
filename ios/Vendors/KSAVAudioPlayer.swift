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
        do {
            self.player = try AVAudioPlayer(data: songData)
            self.player!.volume = 1.0
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {
            }
            self.player!.delegate = self
            self.player!.play()
            self.delegate?.KSAVAudioPlayerBeiginPlay()
        } catch let error as NSError {
            NSLog("Error creating player: \(error.description)")
            self.player = nil
        }
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
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
