//
//  DanuView.swift
//  SpriteKitMania
//
//  Created by Mukhammad Miftakhul As'Adi on 01/07/23.
//

import SwiftUI
import SpriteKit
import GameController

struct DanuView: View {
    
    @ObservedObject var scene = DanuGameScene()
    @State private var isFinish = false
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                Image("coin2")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .position(x: 20, y: 40)
                    .zIndex(10)
                
                Text("\(String(scene.score))")
                    .font(.title)
                    .fontWeight(.heavy)
                    .position(x: 70, y: 42)
                    .zIndex(10)
                
                Image("heart")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .position(x: 160, y: 40)
                    .zIndex(10)
                
                Text("\(String(scene.life))")
                    .font(.title)
                    .fontWeight(.heavy)
                    .position(x: 210, y: 42)
                    .zIndex(10)
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                
                    .onReceive(scene.$isFinish) { newValue in
                        
                        isFinish = newValue
//                        dismiss()
                    }
                    .navigationDestination(isPresented: $isFinish) {
                        NewGameView()
                    }
            }
        }
        
        
    }
    
}

struct DanuView_Previews: PreviewProvider {
    static var previews: some View {
        DanuView().previewInterfaceOrientation(.landscapeLeft)
    }
}
