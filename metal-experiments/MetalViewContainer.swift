//
//  MetalViewContainer.swift
//  metal-experiments
//
//  Created by Frank Hampus Weslien on 2023-05-10.
//
import SwiftUI
import MetalKit
import Foundation

struct MetalViewContainer: NSViewRepresentable {
    
    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
    }
    
    typealias NSViewType = MTKView
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        }
        
        func draw(in view: MTKView) {
        
        }
    }
}


// MTKViewDelegate



