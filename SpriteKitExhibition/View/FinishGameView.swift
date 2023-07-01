//
//  FinishGameView.swift
//  SpriteKitExhibition
//
//  Created by Sayed Zulfikar on 01/07/23.
//

import SwiftUI
import SpriteKit

class ParticleScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .clear
        
        if let emitter1 = SKEmitterNode(fileNamed: "MyParticle"){
            emitter1.position.y = size.height
            emitter1.position.x = size.width / 2
            emitter1.particleColorSequence = nil
            emitter1.particleColorBlendFactor = 1
            emitter1.particleColorBlueRange = 1
            emitter1.particleColorGreenRange = 1
            emitter1.particleColorRedRange = 1
            addChild(emitter1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct FinishGameView: View {
    @State private var navigateToHome = false
    var score: Int
    var gameType: Int
    
    var body: some View {
        
        NavigationStack{
            
            ZStack {
                
                GeometryReader { geo in SpriteView(scene:ParticleScene(size: geo.size), options: [.allowsTransparency])}
                
                VStack {
                    Spacer()
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("🎊 Congratulations! 🎊")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.pink)
                        .lineLimit(1)
                    
                    
                    NavigationLink("Home")
                    {
                        NewGameView()
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                    .buttonStyle(ScaleButtonStyle())
                    
                    NavigationLink("Restart")
                    {
                        if gameType == 0 {
                            BirdHuntView()
                        }
                        else {
                            DanuView()
                        }
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                    .buttonStyle(ScaleButtonStyle())
                    
                    Spacer()
                }
                .padding()
            }
            .background(.black)
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
    }
    
    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.98 : 1)
        }
    }
}

struct FinishGameView_Previews: PreviewProvider {
    static var previews: some View {
        FinishGameView(score: 0, gameType: 0)
    }
}
