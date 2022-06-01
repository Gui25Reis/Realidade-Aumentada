/* Gui Reis & Gabi Namie     -    Created on 01/06/22 */


/// Protocolo para comunicação da View Controller com o delegate do ARKit
protocol MainControllerDelegate: AnyObject {
    func setTextLabel(with text: String) -> Void
}
