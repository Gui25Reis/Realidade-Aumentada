/* Gui Reis & Gabi Namie     -    Created on 01/06/22 */


/// Protocolo para comunicação da View Controller com o delegate do ARKit
protocol MainControllerDelegate: AnyObject {
    func startTimer() -> Void
    func getStatus() -> ARStatus
    func addEmojiRecognized(with emoji: Emojis) -> Void
    
    func updateStatus(to status: ARStatus) -> Void
}
