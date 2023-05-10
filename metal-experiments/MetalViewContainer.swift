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
        
        // mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        // mtkView.drawableSize = mtkView.frame.size
        //mtkView.enableSetNeedsDisplay = true
        
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
    }
    
    typealias NSViewType = MTKView
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        
        let device: MTLDevice
        let mtlCommandQueue: MTLCommandQueue
        let onscreenCommandBuffer: MTLCommandBuffer
        
        override init() {
            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError( "Failed to get the system's default Metal device." )
            }
            self.device = device
            
            guard let mtlCommandQueue = device.makeCommandQueue() else {
                fatalError( "Failed to get the system's default Metal device." )
            }
            self.mtlCommandQueue = mtlCommandQueue
            
            guard let onscreenCommandBuffer = mtlCommandQueue.makeCommandBuffer() else {
                fatalError( "Failed to get the system's default Metal device." )
            }
            self.onscreenCommandBuffer = onscreenCommandBuffer
            
            super.init()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

        }
        
        func draw(in view: MTKView) {
            // BEGIN encoding your onscreen render pass.
            // Obtain a render pass descriptor generated from the drawable's texture.
            // (`currentRenderPassDescriptor` implicitly obtains the current drawable.)
            // If there's a valid render pass descriptor, use it to render to the current drawable.
           
            if let onscreenDescriptor = view.currentRenderPassDescriptor,
            let mtlCommandEncoder = onscreenCommandBuffer.makeRenderCommandEncoder(descriptor: onscreenDescriptor) {
                /* Set render state and resources.
                   ...
                 */
                /* Issue draw calls.
                   ...
                 */
                // mtlCommandEncoder describes a graphics rendering pipeline
                mtlCommandEncoder
                
                
                mtlCommandEncoder.endEncoding()
                // END encoding your onscreen render pass.
                
                // Register the drawable's presentation.
                if let currentDrawable = view.currentDrawable {
                    onscreenCommandBuffer.present(currentDrawable)
                }
            }

            // Finalize your onscreen CPU work and commit the command buffer to a GPU.
            onscreenCommandBuffer.commit()
        
        }
    }
}


// MTKViewDelegate



