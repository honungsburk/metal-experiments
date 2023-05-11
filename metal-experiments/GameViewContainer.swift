
import SwiftUI

struct GameViewContainer: NSViewRepresentable {
    
    
    func makeNSView(context: Context) -> GameView {
        let gameView = GameView(frame: NSMakeRect(0, 0, 1080, 720))
        gameView.autoresizingMask = [.height, .width]
        
        return gameView
    }
    
    func updateNSView(_ nsView: GameView, context: Context) {
    }
}
