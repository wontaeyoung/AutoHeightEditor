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
    
    // MARK: - View
    public var body: some View {
        if isEnabled.wrappedValue {
            enabledEditor
        } else {
            disabledEditor
        }
    }
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

// MARK: - Calculate Width / Height
private extension AutoHeightEditor {
    /// textEditor 시작 높이를 설정합니다.
    func setTextEditorStartHeight() {
        currentTextEditorHeight = uiFont.lineHeight + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
    }
    
    /// text가 가질 수 있는 최대 길이를 설정합니다.
    func setMaxTextWidth(proxy: GeometryProxy) {
        maxTextWidth = proxy.size.width - (const.TEXTEDITOR_INSET_HORIZONTAL * 2 + const.TEXTEDITOR_WIDTH_HORIZONTAL_BUFFER)
    }
    
    /// line count를 통해 textEditor 현재 높이를 계산해서 업데이트합니다.
    func updateTextEditorCurrentHeight() {
        // 총 라인 갯수
        let totalLineCount = newLineCount + autoLineCount
        
        // 총 라인 갯수가 maxCount 이상이면 최대 높이로 고정
        guard totalLineCount < maxLineCount else {
            currentTextEditorHeight = maxHeight
            return
        }
        
        // 라인 갯수로 계산한 현재 Editor 높이
        let currentHeight = (totalLineCount * (uiFont.lineHeight + lineSpace))
        - lineSpace + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
        
        // View의 높이를 결정하는 State 변수에 계산된 현재 높이를 할당하여 뷰에 반영
        currentTextEditorHeight = currentHeight
    }
}

// MARK: - Editor View
private extension AutoHeightEditor {
    var enabledEditor: some View {
        VStack {
            Text("개행 갯수 :" + self.newLineCount.description)
            Text("자동개행 갯수 :" + self.autoLineCount.description)
            Text("한 줄 최대길이 :" + self.maxTextWidth.description)
            Text("현재 높이 :" + self.currentTextEditorHeight.description)
            
            GeometryReader { proxy in
                ZStack {
                    TextEditor(text: text)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .modifier(
                            AutoHeightEditorLayoutModifier(
                                font: font,
                                color: .primary,
                                lineSpace: lineSpace,
                                maxHeight: currentTextEditorHeight,
                                horizontalInset: const.TEXTEDITOR_INSET_HORIZONTAL,
                                bottomInset: const.TEXTEDITOR_INSET_BOTTOM
                            )
                        )
                    
                    if hasBorder {
                        RoundedRectangle(cornerRadius: const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                            .stroke()
                            .foregroundColor(.gray)
                    }
                    
                }
                .onAppear {
                    setTextEditorStartHeight()
                    setMaxTextWidth(proxy: proxy)
                }
                .onChange(of: text.wrappedValue) { n in
                    updateTextEditorCurrentHeight()
                    updatePatternMatched()
                }
            }
            .frame(maxHeight: currentTextEditorHeight)
        }
    }
    
    var disabledEditor: some View {
        ZStack {
            TextEditor(
                text: .constant(disabledInformationText)
            )
            .modifier(
                AutoHeightEditorLayoutModifier(
                    font: font,
                    color: .black,
                    lineSpace: lineSpace,
                    maxHeight: currentTextEditorHeight,
                    horizontalInset: const.TEXTEDITOR_INSET_HORIZONTAL,
                    bottomInset: const.TEXTEDITOR_INSET_BOTTOM
                )
            )
            .disabled(true)
            
            if hasBorder {
                RoundedRectangle(cornerRadius: const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                    .stroke()
                    .foregroundColor(.gray)
                    .background(
                        Color.gray.opacity(0.7)
                    )
                    .cornerRadius(const.TEXTEDITOR_STROKE_CORNER_RADIUS)
            }
        }
        .frame(maxHeight: currentTextEditorHeight)
        .onAppear {
            setTextEditorStartHeight()
        }
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
