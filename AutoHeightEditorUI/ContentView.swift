import SwiftUI
import AutoHeightEditor

struct ContentView: View {
    @State private var text = "123"
    @State private var isEnabled: Bool = true
    @State private var isMatched: Bool = false
    
    var body: some View {
        VStack {
            AutoHeightEditor(
                text: $text,
                lineSpace: 10,
                isEnabled: $isEnabled,
                hasBorder: true,
                disabledInformationText: "밴입니다.",
                regExpPattern: #"^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,3}+$"#,
                isPatternMatched: $isMatched)
            
            Text(isMatched ? "일치" : "불일치")
            
            Toggle(isOn: $isEnabled) {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
