//
//  SoundManager.swift
//  SpriteKitExhibition
//
//  Created by Sayed Zulfikar on 01/07/23.
//

import Foundation
import AVFoundation

class SoundManager{
    static let instance = SoundManager()
    
    var player : AVAudioPlayer?
    
    func OBPlayBGSound(){
        guard let url = Bundle.main.url(forResource: "onboarding-BGM", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.numberOfLoops = -1
            player?.play()
        } catch let error{
            print("error playing sound. \(error.localizedDescription)")
        }
    }
    
    func OBStopBGSound(){
        guard let url = Bundle.main.url(forResource: "onboarding-BGM", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.pause()
        } catch let error{
            print("error stopping sound. \(error.localizedDescription)")
        }
    }
    
    func BirdHuntPlayBGSound(){
        guard let url = Bundle.main.url(forResource: "birdHunt-BGM", withExtension: "wav")
        else {
            print("semfax")
            return
        }
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.numberOfLoops = -1
            player?.play()
        } catch let error{
            print("error playing sound. \(error.localizedDescription)")
        }
    }
    
    func BirdHuntStopBGSound(){
        guard let url = Bundle.main.url(forResource: "birdHunt-BGM", withExtension: ".wav") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.pause()
        } catch let error{
            print("error stopping sound. \(error.localizedDescription)")
        }
    }
    
    func GameOverPlaySound(){
        guard let url = Bundle.main.url(forResource: "game-over", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.numberOfLoops = -1
            player?.play()
        } catch let error{
            print("error playing sound. \(error.localizedDescription)")
        }
    }
    
    func GameOverStopSound(){
        guard let url = Bundle.main.url(forResource: "game-over", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.stop()
        } catch let error{
            print("error stopping sound. \(error.localizedDescription)")
        }
    }
}
