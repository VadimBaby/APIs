//
//  SpeechGoogleAPIView.swift
//  APIs
//
//  Created by Вадим Мартыненко on 13.10.2023.
//

import SwiftUI

struct SpeechGoogleAPIView: View {
    
    @StateObject private var viewModel = SpeechGoogleAPIViewModel()
    
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            VStack {
                TextField("Write your text...", text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 15))
                    .padding()
                
                Button(action: {
                    viewModel.getVoice(text: text)
                }, label: {
                    Text("Turn To Speech")
                        .tint(Color.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .clipShape(.rect(cornerRadius: 15))
                        .padding(.horizontal)
                })
                
                if viewModel.isLoading {
                    HStack(alignment: .center){
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .padding()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                } else if let voice = viewModel.voice, let currentTime = viewModel.currentTime {
                    HStack {
                        Button(action: {
                            if viewModel.isPlaying {
                                viewModel.pauseVoice()
                            } else {
                                viewModel.playVoice()
                            }
                        }, label: {
                            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.black)
                                .contentTransition(.symbolEffect(.replace))
                        })
                        
                        Spacer()
                        Text(roundTimeInterval(currentTime: currentTime, duration: voice.duration))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 15))
                    .padding()
                }
            }
            
            Spacer()
            
            VStack(spacing: 30) {
                HStack{
                    Text("Speaker:")
                        .font(.title3)
                    Spacer()
                    Picker("Choose Speaker", selection: $viewModel.speaker) {
                        ForEach(Speakers.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                    .tint(Color.primary)

                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(.rect(cornerRadius: 15))
                
                VStack{
                    TextField("API KEY", text: $viewModel.rapidKey)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(.rect(cornerRadius: 15))
                    HStack{
                        Button(action: {
                            viewModel.rapidKey = SpeechGoogleAPIConstants.rapidKey
                        }, label: {
                            Text("Paste Default API KEY")
                                .tint(Color.white)
                                .padding()
                                .background(Color.green)
                                .clipShape(.rect(cornerRadius: 15))
                        })
                        Spacer()
                        Button(action: {
                            viewModel.rapidKey = ""
                        }, label: {
                            Text("Clear")
                                .tint(Color.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(.rect(cornerRadius: 15))
                        })
                    }
                }
            }
            .padding()
        }
        .onDisappear(perform: {
            viewModel.cancel()
        })
    }
}

extension SpeechGoogleAPIView {
    private func roundTimeInterval(currentTime: TimeInterval, duration: TimeInterval) -> String {
        let secondsCurrentTime = Int(floor(Double(currentTime)))
        let minutesCurrentTime = Int(floor(Double(secondsCurrentTime) / 60))
        let remainingSecondsCurrentTime = secondsCurrentTime % 60
        let formatedStringCurrentTime = String(format: "%d:%02d", minutesCurrentTime, remainingSecondsCurrentTime)
        
        
        let secondsDuration = Int(floor(Double(duration)))
        let minutesDuration = Int(floor(Double(secondsDuration) / 60))
        let remainingSecondsDuration = secondsDuration % 60
        let formatedStringDuration = String(format: "%d:%02d", minutesDuration, remainingSecondsDuration)
        
        
        return "\(formatedStringCurrentTime) | \(formatedStringDuration)"
    }
}

#Preview {
    SpeechGoogleAPIView()
}
