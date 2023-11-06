import SwiftUI

public struct AutoHeightEditor: View {
    // MARK: - Property
    private let const = TextEditorConst.self
    
    private let text: Binding<String>
    private let font: Font
    private let lineSpace: CGFloat
    private let isEnabled: Binding<Bool>
    private let hasBorder: Bool
    private let disabledInformationText: String
    
    // MARK: Initializer에서 계산을 통해 결정되는 프로퍼티
    private let maxLineCount: CGFloat
    private let uiFont: UIFont
    private let maxHeight: CGFloat
    
    @State private var currentTextEditorHeight: CGFloat = 0
    @State private var maxTextWidth: CGFloat = 0
    
    // MARK: - Initializer
    /// 파라미터 font = .body, lineSpace = 2 기본값 지정
    public init (
        text: Binding<String>,
        font: Font = .body,
        lineSpace: CGFloat = 2,
        isEnabled: Binding<Bool>,
        hasBorder: Bool,
        disabledInformationText: String
    ) {
        // MARK: Required
        self.text = text
        self.font = font
        self.lineSpace = lineSpace
        self.isEnabled = isEnabled
        self.hasBorder = hasBorder
        self.disabledInformationText = disabledInformationText
        
        // MARK: Calculated
        self.maxLineCount = const.TEXTEDITOR_MAX_LINE_COUNT.asFloat
        self.uiFont = UIFont.fontToUIFont(from: font)
        self.maxHeight = (maxLineCount * (uiFont.lineHeight + lineSpace)) + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
    }

// MARK: - Calculate Line
private extension AutoHeightEditor {
    /// 현재 text에 개행문자에 의한 라인 갯수가 몇 줄인지 계산합니다.
    var newLineCount: CGFloat {
        let currentText: String = text.wrappedValue
        let currentLineCount: Int = currentText
            .filter { $0 == "\n" }
            .count + 1
        let newLineCount: CGFloat = currentLineCount > maxLineCount.asInt
        ? maxLineCount
        : currentLineCount.asFloat
        
        return newLineCount
    }
    
    /// 개행 문자 기준으로 텍스트를 분리하고, 각 텍스트 길이가 Editor 길이를 초과하는지 체크하여 필요한 줄바꿈 수를 계산합니다.
    var autoLineCount: CGFloat {
        var counter: Int = 0
        text
            .wrappedValue
            .components(separatedBy: "\n")
            .forEach { line in
                let label = UILabel()
                label.font = .fontToUIFont(from: font)
                label.text = line
                label.sizeToFit()
                let currentTextWidth = label.frame.width
                counter += (currentTextWidth / maxTextWidth).asInt
            }
        
        return counter.asFloat
    }
}
private struct AutoHeightEditorLayoutModifier: ViewModifier {
    let font: Font
    let color: Color
    let lineSpace: CGFloat
    let maxHeight: CGFloat
    let horizontalInset: CGFloat
    let bottomInset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpace)
            .frame(maxHeight: maxHeight)
            .padding(.horizontal, horizontalInset)
            .padding(.bottom, bottomInset)
    }
}
