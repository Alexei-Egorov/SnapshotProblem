import Foundation

class Activity: Identifiable {
    
    let id = UUID()
    var title: String
    
    init(title: String) {
        self.title = title
    }
}
