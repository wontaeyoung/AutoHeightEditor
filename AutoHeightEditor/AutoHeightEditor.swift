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
