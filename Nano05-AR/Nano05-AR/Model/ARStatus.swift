/* Gui Reis & Gabi Namie     -    Created on 07/06/22 */


/// Status para saber quando o AR está ativo ou não
enum ARStatus {
    /// Menu incial
    case notStarted
    
    /// Fazendo o reconhecimento
    case inProgress
    
    /// Tirando a foto
    case takingPhoto
    
    /// Finalizou todas as etapas
    case ended
}
