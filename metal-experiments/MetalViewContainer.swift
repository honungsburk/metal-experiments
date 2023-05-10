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
        MTKView()
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
    }
    
    typealias NSViewType = MTKView
    
}
