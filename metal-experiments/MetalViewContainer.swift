//
//  MetalViewContainer.swift
//  metal-experiments
//
//  Created by Frank Hampus Weslien on 2023-05-10.
//
import SwiftUI
import MetalKit
import Foundation


// https://developer.apple.com/library/archive/documentation/Miscellaneous/Conceptual/MetalProgrammingGuide/Render-Ctx/Render-Ctx.html#//apple_ref/doc/uid/TP40014221-CH7-SW1

struct MetalViewContainer: NSViewRepresentable {
    
    
    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView(frame: NSMakeRect(0, 0, 1080, 720))
        mtkView.delegate = context.coordinator
        mtkView.autoresizingMask = [.height, .width]
        
        // mtkView.framebufferOnly = false
        //The color the screen is cleared with between each frame
        mtkView.clearColor = MTLClearColor(red: 0.34, green: 0.6, blue: 0.1, alpha: 1.0)
        
        // Must match the output of our fragment shader
        mtkView.colorPixelFormat = .bgra8Unorm
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
        let commandQueue: MTLCommandQueue
        let onscreenCommandBuffer: MTLCommandBuffer
        let renderPipelineState: MTLRenderPipelineState
        
        override init() {
            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError( "Failed to get the system's default Metal device." )
            }
            self.device = device
            
            print(device.debugDescription ?? "no debug description")
            
            // A queue that pushes buffers to the screen in the correct order.
            guard let mtlCommandQueue = device.makeCommandQueue() else {
                fatalError( "Failed to get the system's default Metal device." )
            }
            self.commandQueue = mtlCommandQueue
            
            guard let onscreenCommandBuffer = mtlCommandQueue.makeCommandBuffer() else {
                fatalError( "Failed to get the system's default Metal device." )
            }
            self.onscreenCommandBuffer = onscreenCommandBuffer
            
            // Create Render Pipeline
            
            /*
            guard let bundleID = Bundle.main.bundleIdentifier else {
                fatalError( "Could not locate bundel ID" )
            }
            
            guard let bundle = Bundle(identifier: bundleID) else {
                fatalError( "Could not load bundle" )
            }
            
            guard let metalLibURL = bundle.url(forResource: "Conv", withExtension: "metallib", subdirectory: "Metal") else {
                fatalError( "Could not load url to metal library" )
            }
            
            guard let library = try? device.makeLibrary(URL: metalLibURL) else {
                fatalError( "Could not create metal library" )
            }
             */
            
            guard let library = device.makeDefaultLibrary() else {
                fatalError( "Could not create metal library" )
            }
            let fragmentFunction = library.makeFunction(name: "basic_fragment_shader")!
            let vertexFunction = library.makeFunction(name: "basic_vertex_shader")!
            
            let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
            renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            renderPipelineDescriptor.fragmentFunction = fragmentFunction
            renderPipelineDescriptor.vertexFunction =  vertexFunction
            
            renderPipelineState = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            
            
            super.init()
            
        }
        
        
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

        }
        
        func draw(in view: MTKView) {
            // BEGIN encoding your onscreen render pass.
            // Obtain a render pass descriptor generated from the drawable's texture.
            // (`currentRenderPassDescriptor` implicitly obtains the current drawable.)
            // If there's a valid render pass descriptor, use it to render to the current drawable.
           
            if  let currentDrawable = view.currentDrawable,
                let renderPassDescriptor = view.currentRenderPassDescriptor,
                let renderCommandEncoder = onscreenCommandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
              
                //let commandBuffer =  self.commandQueue.makeCommandBuffer()
                renderCommandEncoder.setRenderPipelineState(renderPipelineState)

                // Send info to rendercommandencoder
                
                renderCommandEncoder.endEncoding()
                // END encoding your onscreen render pass.
                onscreenCommandBuffer.present(currentDrawable)
                
                // Finalize your onscreen CPU work and commit the command buffer to a GPU.
                onscreenCommandBuffer.commit()
                print("commit")
            }
        
        }
    }
}


// MTKViewDelegate



