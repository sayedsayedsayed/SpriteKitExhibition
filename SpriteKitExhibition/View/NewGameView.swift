//
//  NewGameView.swift
//  SpriteKitExhibition
//
//  Created by Sayed Zulfikar on 01/07/23.
//

import SwiftUI

struct NewGameView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                
                LinearGradient(colors: [Color .blue .opacity(0.7), Color .green .opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                VStack {
                    
                    Rectangle()
                        .frame(width: 400, height: 100.0)
                        .scaledToFit()
                        .overlay(
                            NavigationLink("Bird Hunt"){
                                BirdHuntView()
                                    .onAppear {
                                    let hostingController = PortraitHostingController(rootView: BirdHuntView())
                                    UIApplication.shared.windows.first?.rootViewController = hostingController
                                }
                            }
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    Rectangle()
                        .frame(width: 400, height: 100.0)
                        .scaledToFit()
                        .overlay(
                            NavigationLink("Jump Danu Jump!"){
                                DanuView()
                                    .onAppear {
                                    let hostingController = LandscapeHostingController(rootView: DanuView())
                                    UIApplication.shared.windows.first?.rootViewController = hostingController
                                }
                            }
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
            .onAppear{
                SoundManager.instance.BirdHuntStopBGSound()
                SoundManager.instance.GameOverStopSound()
                
                SoundManager.instance.OBPlayBGSound()
            }
        }
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameView()
    }
}
