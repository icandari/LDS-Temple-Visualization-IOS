//
//  SliderView.swift
//  LDS-Temple-Visualization-IOS
//
//  Created by tiantian on 2020/7/13.
//  Copyright © 2020 Litian Zhang. All rights reserved.
//

import SwiftUI

struct SliderView: View {
    
    @EnvironmentObject var sharedValues: SharedValues
    @ObservedObject var imageSpiralViewModel: ImageSpiral
    
    // we update spiral here,
    // we call functions in imagespiral view mode to call functions in spiral mode, to change itself
    func updateSpiral() {
        imageSpiralViewModel.getNewTheta(newTheta: sharedValues.sliderProgress)
        imageSpiralViewModel.updateOnScreenTemples(newTheta: sharedValues.sliderProgress)
        
        if imageSpiralViewModel.mode != sharedValues.mode {
            imageSpiralViewModel.changeMode(newMode: sharedValues.mode)
        }
        
        sharedValues.oneTempleInfo.removeAll()
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                HStack {
                    Image(systemName: "arrow.left.square.fill")
                        .onTapGesture {
                            sharedValues.animationInProgress = true
                            // we need to put this in withAnimation, so that we can check if the animation ends so that we can decide to display name label
                            //SwiftUI.withAnimation(.default) {
                                sharedValues.sliderProgress -= 30
                            //}
                            updateSpiral()
                            
                            sharedValues.selectedYearIndex = -1
                        }
                    MySlider(imageSpiralViewModel: imageSpiralViewModel)
                        .frame(maxWidth: (min(sharedValues.currentScreenWidth, sharedValues.currentScreenHeight)) * 0.8)
                        //.background(Color.red)
                    Image(systemName: "arrow.right.square.fill")
                        .onTapGesture {
                            sharedValues.animationInProgress = true
                            //SwiftUI.withAnimation(.default) {
                                sharedValues.sliderProgress += 30
                            //}
                            updateSpiral()
                            
                            sharedValues.selectedYearIndex = -1
                        }
                }
            }
                
            HStack {
                
                // we dont display slider label: start year and current year in landscape mode of phone, because of limited space
                if sharedValues.currentDevice == .phone && sharedValues.orientationInText == "landscape" {
                    // do nothing
                } else {
                    Text("1836")
                        .padding()
                }
                YearDisplayView(startYear: ImageSpiral.startYear, endYear: ImageSpiral.endYear)
                    //.background(Color.red)
                    .padding()
                 
                if sharedValues.currentDevice == .phone && sharedValues.orientationInText == "landscape" {
                    // do nothing
                } else {
                    Text("2020")
                        .padding()
                }
            }
        }
    }
}

struct MySlider: View {
    
    @EnvironmentObject var sharedValues: SharedValues
    
    @ObservedObject var imageSpiralViewModel: ImageSpiral
    
    var body: some View {
        // we use Binding, so that when ever slider progress changes, we can do something
        Slider(value: Binding(
                get: {
                    return Double(sharedValues.sliderProgress)
                },
                set: {(newValue) in
                    
                    sharedValues.selectedYearIndex = -1
                    
                    sharedValues.lastSliderProgress = sharedValues.sliderProgress
                    
                    // only run the following code when sliderporgess changed
                    // if not checking newvalue and sliderprogress,
                    // newvalue might be the same as sliderprogress, these lines may excute too
                    // this might cause problems with checking if animation stops
                    
                    if CGFloat(newValue) != sharedValues.sliderProgress {
                        
                        // we update spiral here,
                        // we call functions in imagespiral view mode to call functions in spiral mode, to change it
                        imageSpiralViewModel.getNewTheta(newTheta: sharedValues.sliderProgress)
                        imageSpiralViewModel.updateOnScreenTemples(newTheta: sharedValues.sliderProgress)
                        

//                        if sharedValues.animationInProgress != true {
// we don't need this anymore when we put animatable modifer on each temple to check if animation ends?... accidetally fixed label moving while appearing and disappearing bug...
//                            // we need to put this in withAnimation, so that we can check if the animation ends so that we can decide to display name label
//                            SwiftUI.withAnimation(.none) {
//                                sharedValues.sliderProgress = CGFloat(newValue)
//                            }
//                        }
//
                        sharedValues.animationInProgress = true
                        
                        //sharedValues.animationInProgress = true
                        
//                        SwiftUI.withAnimation(sharedValues.animationOption == "slow" ? sharedValues.mySlowAnimation : sharedValues.animationOption == "fast" ? sharedValues.myFastAnimation : .none) {
//                            sharedValues.sliderProgress = CGFloat(newValue)
//                        }
                        
                        sharedValues.sliderProgress = CGFloat(newValue)
                        
                        
                        
                        if imageSpiralViewModel.mode != sharedValues.mode {
                            imageSpiralViewModel.changeMode(newMode: sharedValues.mode)
                        }
                        
                        sharedValues.oneTempleInfo.removeAll()
                        
                        sharedValues.singleTempleShow = false
                    }
                    
//                    print("sharedValues.lastSliderProgress is \(sharedValues.lastSliderProgress)")
                    //print("sharedValues.sliderProgress is \(sharedValues.sliderProgress)")
//                    print("newValue is \(newValue)")

                    
                }),
               in: 11...7500, step: 1)
            //.background(Color.red)
        }
}
