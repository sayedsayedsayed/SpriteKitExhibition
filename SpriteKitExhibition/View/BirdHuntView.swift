//
//  BirdHuntView.swift
//  SpriteKitExhibition
//
//  Created by Sayed Zulfikar on 01/07/23.
//

import SwiftUI
import SpriteKit


var spriteScene: SKScene {
    let scene = BirdHuntScene()
    return scene
}

struct BirdHuntView: View {
    @ObservedObject var scene = BirdHuntScene()
    var body: some View {
        NavigationView{
            ZStack{
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .onAppear{
                          SoundManager.instance.BirdHuntPlayBGSound()
                    }
                
                if scene.gameOver == true {
                    FinishGameView(score: scene.score)
                }
            }
            
        }
        .navigationBarBackButtonHidden()
    }
}

struct BirdHuntView_Previews: PreviewProvider {
    static var previews: some View {
        BirdHuntView()
    }
}
