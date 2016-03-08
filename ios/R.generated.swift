// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift

import Foundation
import Rswift
import UIKit

struct R: Rswift.Validatable {
  static func validate() throws {
    try intern.validate()
  }
  
  struct file {
    static let infoPlist = FileResource(bundle: _R.hostingBundle, name: "Info", pathExtension: "plist")
    
    static func infoPlist(_: Void) -> NSURL? {
      let fileResource = R.file.infoPlist
      return fileResource.bundle?.URLForResource(fileResource)
    }
    
    static func infoPlist(_: Void) -> String? {
      let fileResource = R.file.infoPlist
      return fileResource.bundle?.pathForResource(fileResource)
    }
  }
  
  struct font {
    
  }
  
  struct image {
    static let audio = ImageResource(bundle: _R.hostingBundle, name: "Audio")
    static let chat_animation1 = ImageResource(bundle: _R.hostingBundle, name: "chat_animation1")
    static let chat_animation2 = ImageResource(bundle: _R.hostingBundle, name: "chat_animation2")
    static let chat_animation3 = ImageResource(bundle: _R.hostingBundle, name: "chat_animation3")
    static let chat_animation_white1 = ImageResource(bundle: _R.hostingBundle, name: "chat_animation_white1")
    static let chat_animation_white2 = ImageResource(bundle: _R.hostingBundle, name: "chat_animation_white2")
    static let chat_animation_white3 = ImageResource(bundle: _R.hostingBundle, name: "chat_animation_white3")
    static let chat_record_circle = ImageResource(bundle: _R.hostingBundle, name: "Chat_record_circle")
    static let chatfrom_bg_normal = ImageResource(bundle: _R.hostingBundle, name: "chatfrom_bg_normal")
    static let chatto_bg_normal = ImageResource(bundle: _R.hostingBundle, name: "chatto_bg_normal")
    static let credit = ImageResource(bundle: _R.hostingBundle, name: "Credit")
    static let detail = ImageResource(bundle: _R.hostingBundle, name: "Detail")
    static let edit = ImageResource(bundle: _R.hostingBundle, name: "Edit")
    static let eenglistMini = ImageResource(bundle: _R.hostingBundle, name: "Eenglist-mini")
    static let english = ImageResource(bundle: _R.hostingBundle, name: "English")
    static let feedback = ImageResource(bundle: _R.hostingBundle, name: "Feedback")
    static let filter = ImageResource(bundle: _R.hostingBundle, name: "Filter")
    static let friends = ImageResource(bundle: _R.hostingBundle, name: "Friends")
    static let hightColor = ImageResource(bundle: _R.hostingBundle, name: "HightColor")
    static let home = ImageResource(bundle: _R.hostingBundle, name: "Home")
    static let howItWorks = ImageResource(bundle: _R.hostingBundle, name: "How it works")
    static let launchImage = ImageResource(bundle: _R.hostingBundle, name: "LaunchImage")
    static let logo = ImageResource(bundle: _R.hostingBundle, name: "logo")
    static let me = ImageResource(bundle: _R.hostingBundle, name: "Me")
    static let message = ImageResource(bundle: _R.hostingBundle, name: "Message")
    static let more = ImageResource(bundle: _R.hostingBundle, name: "More")
    static let personMessage = ImageResource(bundle: _R.hostingBundle, name: "PersonMessage")
    static let personPhone = ImageResource(bundle: _R.hostingBundle, name: "PersonPhone")
    static let receiving_Solid = ImageResource(bundle: _R.hostingBundle, name: "Receiving_Solid")
    static let record = ImageResource(bundle: _R.hostingBundle, name: "record")
    static let schedule = ImageResource(bundle: _R.hostingBundle, name: "Schedule")
    static let search = ImageResource(bundle: _R.hostingBundle, name: "Search")
    static let sending_Solid = ImageResource(bundle: _R.hostingBundle, name: "Sending_Solid")
    static let settings = ImageResource(bundle: _R.hostingBundle, name: "Settings")
    static let share = ImageResource(bundle: _R.hostingBundle, name: "Share")
    static let speech = ImageResource(bundle: _R.hostingBundle, name: "Speech")
    static let tintColor = ImageResource(bundle: _R.hostingBundle, name: "TintColor")
    static let tracking = ImageResource(bundle: _R.hostingBundle, name: "Tracking")
    static let uSA = ImageResource(bundle: _R.hostingBundle, name: "USA")
    static let user = ImageResource(bundle: _R.hostingBundle, name: "User")
    static let userMini = ImageResource(bundle: _R.hostingBundle, name: "UserMini")
    
    static func audio(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.audio, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chat_animation1(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chat_animation1, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chat_animation2(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chat_animation2, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chat_animation3(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chat_animation3, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chat_animation_white1(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chat_animation_white1, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chat_animation_white2(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chat_animation_white2, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chat_animation_white3(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chat_animation_white3, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chat_record_circle(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chat_record_circle, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chatfrom_bg_normal(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chatfrom_bg_normal, compatibleWithTraitCollection: traitCollection)
    }
    
    static func chatto_bg_normal(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.chatto_bg_normal, compatibleWithTraitCollection: traitCollection)
    }
    
    static func credit(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.credit, compatibleWithTraitCollection: traitCollection)
    }
    
    static func detail(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.detail, compatibleWithTraitCollection: traitCollection)
    }
    
    static func edit(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.edit, compatibleWithTraitCollection: traitCollection)
    }
    
    static func eenglistMini(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.eenglistMini, compatibleWithTraitCollection: traitCollection)
    }
    
    static func english(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.english, compatibleWithTraitCollection: traitCollection)
    }
    
    static func feedback(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.feedback, compatibleWithTraitCollection: traitCollection)
    }
    
    static func filter(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.filter, compatibleWithTraitCollection: traitCollection)
    }
    
    static func friends(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.friends, compatibleWithTraitCollection: traitCollection)
    }
    
    static func hightColor(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.hightColor, compatibleWithTraitCollection: traitCollection)
    }
    
    static func home(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.home, compatibleWithTraitCollection: traitCollection)
    }
    
    static func howItWorks(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.howItWorks, compatibleWithTraitCollection: traitCollection)
    }
    
    static func launchImage(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.launchImage, compatibleWithTraitCollection: traitCollection)
    }
    
    static func logo(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.logo, compatibleWithTraitCollection: traitCollection)
    }
    
    static func me(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.me, compatibleWithTraitCollection: traitCollection)
    }
    
    static func message(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.message, compatibleWithTraitCollection: traitCollection)
    }
    
    static func more(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.more, compatibleWithTraitCollection: traitCollection)
    }
    
    static func personMessage(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.personMessage, compatibleWithTraitCollection: traitCollection)
    }
    
    static func personPhone(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.personPhone, compatibleWithTraitCollection: traitCollection)
    }
    
    static func receiving_Solid(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.receiving_Solid, compatibleWithTraitCollection: traitCollection)
    }
    
    static func record(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.record, compatibleWithTraitCollection: traitCollection)
    }
    
    static func schedule(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.schedule, compatibleWithTraitCollection: traitCollection)
    }
    
    static func search(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.search, compatibleWithTraitCollection: traitCollection)
    }
    
    static func sending_Solid(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.sending_Solid, compatibleWithTraitCollection: traitCollection)
    }
    
    static func settings(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.settings, compatibleWithTraitCollection: traitCollection)
    }
    
    static func share(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.share, compatibleWithTraitCollection: traitCollection)
    }
    
    static func speech(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.speech, compatibleWithTraitCollection: traitCollection)
    }
    
    static func tintColor(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.tintColor, compatibleWithTraitCollection: traitCollection)
    }
    
    static func tracking(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.tracking, compatibleWithTraitCollection: traitCollection)
    }
    
    static func uSA(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.uSA, compatibleWithTraitCollection: traitCollection)
    }
    
    static func user(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.user, compatibleWithTraitCollection: traitCollection)
    }
    
    static func userMini(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.userMini, compatibleWithTraitCollection: traitCollection)
    }
  }
  
  private struct intern: Rswift.Validatable {
    static func validate() throws {
      try _R.validate()
    }
  }
  
  struct nib {
    static let launchScreen = _R.nib._LaunchScreen()
    
    static func launchScreen(_: Void) -> UINib {
      return UINib(resource: R.nib.launchScreen)
    }
  }
  
  struct reuseIdentifier {
    static let languageCell: ReuseIdentifier<KSLanguageTableViewCell> = ReuseIdentifier(identifier: "languageCell")
    static let lastMessageCell: ReuseIdentifier<KSPersonListTableViewCell> = ReuseIdentifier(identifier: "lastMessageCell")
    static let personCell: ReuseIdentifier<KSPersonListTableViewCell> = ReuseIdentifier(identifier: "personCell")
    static let playAudioCell: ReuseIdentifier<KSPlayAudioTableViewCell> = ReuseIdentifier(identifier: "playAudioCell")
    static let reportOrSwitchCell: ReuseIdentifier<KSReportOrSwitchTableViewCell> = ReuseIdentifier(identifier: "reportOrSwitchCell")
    static let searchCell: ReuseIdentifier<UITableViewCell> = ReuseIdentifier(identifier: "searchCell")
    static let subtitleCell: ReuseIdentifier<UITableViewCell> = ReuseIdentifier(identifier: "subtitleCell")
  }
  
  struct segue {
    
  }
  
  struct storyboard {
    static let login = _R.storyboard.login()
    static let main = _R.storyboard.main()
    
    static func login(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.login)
    }
    
    static func main(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.main)
    }
  }
}

struct _R: Rswift.Validatable {
  static let hostingBundle = NSBundle(identifier: "com.king.polyge")
  
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    struct _LaunchScreen: NibResourceType {
      let bundle = _R.hostingBundle
      let name = "LaunchScreen"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIView? {
        return instantiateWithOwner(ownerOrNil, options: optionsOrNil)[0] as? UIView
      }
    }
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try login.validate()
      try main.validate()
    }
    
    struct login: StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UINavigationController
      
      let bundle = _R.hostingBundle
      let name = "Login"
      
      func login() -> KSLoginViewController? {
        return UIStoryboard(resource: self).instantiateViewControllerWithIdentifier("login") as? KSLoginViewController
      }
      
      func register() -> KSRegisterViewController? {
        return UIStoryboard(resource: self).instantiateViewControllerWithIdentifier("register") as? KSRegisterViewController
      }
      
      static func validate() throws {
        if UIImage(named: "logo") == nil { throw ValidationError(description: "[R.swift] Image named 'logo' is used in storyboard 'Login', but couldn't be loaded.") }
        if _R.storyboard.login().login() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'login' could not be loaded from storyboard 'Login' as 'KSLoginViewController'.") }
        if _R.storyboard.login().register() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'register' could not be loaded from storyboard 'Login' as 'KSRegisterViewController'.") }
      }
    }
    
    struct main: StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = KSTabBarViewController
      
      let bundle = _R.hostingBundle
      let name = "Main"
      
      func kSPersonViewController() -> KSPersonViewController? {
        return UIStoryboard(resource: self).instantiateViewControllerWithIdentifier("KSPersonViewController") as? KSPersonViewController
      }
      
      static func validate() throws {
        if UIImage(named: "User") == nil { throw ValidationError(description: "[R.swift] Image named 'User' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "Search") == nil { throw ValidationError(description: "[R.swift] Image named 'Search' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "Filter") == nil { throw ValidationError(description: "[R.swift] Image named 'Filter' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "Audio") == nil { throw ValidationError(description: "[R.swift] Image named 'Audio' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "Message") == nil { throw ValidationError(description: "[R.swift] Image named 'Message' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "Me") == nil { throw ValidationError(description: "[R.swift] Image named 'Me' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "Home") == nil { throw ValidationError(description: "[R.swift] Image named 'Home' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "English") == nil { throw ValidationError(description: "[R.swift] Image named 'English' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "PersonMessage") == nil { throw ValidationError(description: "[R.swift] Image named 'PersonMessage' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "Share") == nil { throw ValidationError(description: "[R.swift] Image named 'Share' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "PersonPhone") == nil { throw ValidationError(description: "[R.swift] Image named 'PersonPhone' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIImage(named: "USA") == nil { throw ValidationError(description: "[R.swift] Image named 'USA' is used in storyboard 'Main', but couldn't be loaded.") }
        if _R.storyboard.main().kSPersonViewController() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'kSPersonViewController' could not be loaded from storyboard 'Main' as 'KSPersonViewController'.") }
      }
    }
  }
}