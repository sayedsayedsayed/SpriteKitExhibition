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
    
    var scene = DanuGameScene()
    
    
    var body: some View {
        VStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}

struct DanuView_Previews: PreviewProvider {
    static var previews: some View {
        DanuView().previewInterfaceOrientation(.landscapeLeft)
    }
}
