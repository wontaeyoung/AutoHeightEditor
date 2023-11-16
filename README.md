[![Platform](https://img.shields.io/badge/Platform-iOS_iPadOS-orange.svg)](https://developer.apple.com/ios/)
[![Deployments](https://img.shields.io/badge/Deployments-14.0+-skyblue.svg)](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-14-release-notes)
[![UseFor](https://img.shields.io/badge/UseFor-SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-khaki.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/wontaeyoung/AutoHeightEditor/blob/main/LICENSE)
[![Github](https://img.shields.io/badge/Author-wontaeyoung-red.svg)](https://www.github.com/wontaeyoung)

[Read English Translation](https://github.com/wontaeyoung/AutoHeightEditor/blob/main/README_ENG.md)

<br>

`AutoHeightEditor`는 Dynamic Height 기능이 있는 커스텀 `TextEditor` 라이브러리입니다. 

<br>

# 제작 배경

이 라이브러리는 제가 프로젝트에 필요해서 직접 구현하게 된 커스텀 `TextEditor`입니다.

제가 진행하고 있는 프로젝트에서 동적으로 높이가 조절되는 입력 인터페이스가 요구사항이었는데, **iOS 16**부터는 `TextField`의 `axis` 파라미터를 통해 Dynamic Height로 동작하는 입력 인터페이스를 쉽게 사용할 수 있습니다.

하지만 프로젝트 최소 지원버전이 **iOS 15.0+**로 결정되었고, 여러 줄의 텍스트 입력을 받기 위해서는 `TextEditor`를 사용해야했습니다.

기본 API로 제공되는 `TextEditor`를 사용해보신분들은 공감하시겠지만 지원하는 기능이 `TextField`에 비해 부족하고, 특히 별도로 높이를 지정해주지 않으면 차지할 수 있는 최대 높이를 가지게 됩니다.

이를 해결하기 위해서 적절한 높이를 동적으로 계산해주는 `AutoHeightEditor`를 커스텀으로 제작하게 되었습니다.

자세한 제작 배경 및 구현 과정은 [블로그](https://velog.io/@wontaeyoung/swiftui4)에서 확인할 수 있습니다.

<br><br>

# 라이브러리 소개

`AutoHeightEditor`는 기본적으로 Dynamic Height이 가장 큰 특징입니다.

이를 구현하기 위해 폰트 높이, 행간, 텍스트 길이, 개행문자를 통해서 적절한 높이로 TextEditor의 높이를 실시간으로 변경합니다.

<br>

## 주요 로직

1. 텍스트에서 `\n`(개행문자)의 갯수를 계산합니다.
2. `TextEditor`의 가로 길이와 입력된 텍스트의 길이를 계산해서 자동 줄바꿈이 몇 번 일어나야하는지 계산합니다.
3. 1번과 2번을 합쳐서 총 줄바꿈 횟수를 계산합니다.
4. 폰트 크기, 행간, 줄바꿈 수를 계산하여 `TextEditor`의 총 높이를 계산합니다.

<br>

## 사용자 편의

최소 1줄 ~ maxLine까지 사용자의 입력에 따라 높이가 변경되고 최대 라인 수, 사용되는 폰트, 행간, 활성화 여부와 같은 선택사항을 파라미터로 전달받아서 반영합니다.

개인적으로 사용하는 컴포넌트를 라이브러리에 맞춰서 수정한만큼, 제가 아닌 다른 사용자가 사용하는 환경을 고려하여 아래 사항들을 추가했습니다.

- isEnabled를 바인딩 받아서 외부에서 활성화 여부 관리 가능
- 고정으로 존재하는 Border 스트로크 사용 여부 선택 가능
- Disabled 안내 문구 커스텀 가능
- 전달받은 정규식 매치 여부를 계산해서 바인딩 된 Bool 변수에 반영

<br>

제작 배경에서 설명한 것처럼 **iOS 16**은 아직은 실무에 적용하기 부담스러운 버전이기 때문에, 이를 고려하여 `TextEditor`가 처음 나온 **iOS 14**부터 사용 가능하도록 구현했습니다.

<br><br>

# 파라미터 리스트

```swift
public init (
    text: Binding<String>,
    font: Font = .body,
    lineSpace: CGFloat = 2,
    maxLine: Int,
    hasBorder: Bool,
    isEnabled: Binding<Bool>,
    disabledPlaceholder: String,
    regExpUse: RegExpUse
)
```

<br><br>

```swift
text: Binding<String>
```

에디터에 바인딩되는 입력 텍스트 문자열입니다. 외부에서 바인딩으로 주입해서 사용합니다.

<br><br>

```swift
font: Font
```

텍스트에 적용할 폰트 타입입니다. Default Value로 `body`가 주입되고, 원하는 다른 폰트가 있다면 주입해서 사용 가능합니다.

<br><br>

```swift
lineSpace: CGFloat
```

텍스트 라인 사이에 들어가는 행 간격입니다. Default Value로 2가 주입되고, 원하는 다른 값이 있다면 주입해서 사용 가능합니다.

<br><br>

```swift
maxLine: Int
```

에디터의 높이가 증가하는 상한선 라인 수입니다. 입력 라인이 늘어날 때 `maxLine`까지 에디터 높이가 증가하고, 그 이후로는 늘어나지 않습니다.

<br><br>

```swift
hasBorder: Bool
```

기본으로 제공되는 `Stroke`의 사용 여부를 결정합니다. 기본 `Stroke`는 Gray 컬러에 20의 CornerRadius 값을 가지고 있습니다.

<br><br>

```swift
isEnabled: Binding<Bool>
```

에디터의 활성화 여부를 결정합니다. 외부에서 바인딩으로 주입하고, 조절해서 사용합니다.

<br><br>

```swift
disabledPlaceholder: String
```

에디터가 비활성화 되어있을 때, 사용자에게 안내하기 위한 문구입니다.

<br><br>

```swift
public enum RegExpUse {
    case use(pattern: String, isMatched: Binding<Bool>)
    case none
}

regExpUse: RegExpUse
```

정규식 매치 여부를 사용하는지를 결정하는 타입입니다. 

사용하지 않으면 `none`, 사용한다면 `use`를 전달합니다. 

`pattern`은 매칭에 사용할 정규식 패턴, `isMatched`는 외부에서 주입하고 활용할 바인딩 값입니다. 

텍스트가 업데이트 될 때마다 정규식을 검사해서 `isMatched`에 전달된 바인딩 변수를 자동으로 업데이트합니다.

<br><br>

# 사용 가이드

우선 기본적인 동작을 확인해보기 위해 `AutoHeightEditor`를 초기화 해보겠습니다.

처음에는 1줄 높이로 시작하고, 입력된 텍스트에 따라 최대 5줄까지 높이가 동적으로 늘어납니다.

`\n`(개행문자)로 일어나는 줄바꿈 뿐만 아니라, 텍스트가 길어져서 자동으로 줄바꿈이 발생하는 순간도 감지해서 높이에 반영합니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/4208a9ae-74aa-4819-a42d-f04a5065e282">

<br><br>

###  최대 라인 수 수정하기

`maxLine`을 조정해서 최대 높이 라인 수를 결정할 수 있습니다.

아래 예시에서는 `7`을 전달해서 7줄 높이까지 늘어나도록 해보겠습니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 7,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/71432a5c-0dbc-400e-b022-ec4ddf428a8d">

<br><br>

### 폰트와 행 간격 수정하기

> 현재 버전에서는 SwiftUI의 기본 `Font` 타입에 없는 값은 사용이 불가합니다. 폰트의 사이즈를 구하기 위해 내부에서 `UIFont`와 1:1 매핑을 하기 때문입니다.

`font`와 `lineSpace`에는 기본값으로 `body`와 `2`가 전달되고 있습니다. 

원하는 값이 있다면 Default Value 대신에 새로운 값을 전달할 수 있습니다.

아래 예시에서는 `title2`와 `10`을 전달해서 폰트 사이즈를 키우고 행 간격도 넓혀보겠습니다.

```swift
AutoHeightEditor(
    text: $text,
    font: .title2,
    lineSpace: 10,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/dca01cbe-3065-4729-a0c8-3628398c2761">

<br><br>

### Border Stroke 커스텀

`hasBorder`를 통해 기본으로 제공되는 테두리 사용 여부를 결정할 수 있습니다.

기본 `Stroke`는 Gray 컬러에 20의 CornerRadius 값을 가지고 있습니다.

아래 예시에서는 `hasBorder`의 값을 false로 전달하여 테두리를 삭제해보겠습니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: false,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/d18d2610-7a94-4270-a16e-2b311f8b7c57">

<br><br>

외부에서 `overlay`를 사용하여 원하는 디자인을 커스텀으로 작성할 수 있습니다.

아래 예시에서는 기본 테두리를 삭제하고, overlay로 사각형 스타일의 테두리를 그려보겠습니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: false,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
.overlay {
    Rectangle()
        .stroke()
}
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/33dbfba0-1719-48c3-b23e-a093a4919aef">

<br><br>

### 에디터 사용 활성화 관리

`isEnabled`로 에디터의 터치 이벤트 수신 여부를 조정할 수 있습니다.

외부에서 관리하기 위해 바인딩으로 전달받아 사용합니다.

`disabled`되면 `disabledPlaceholder`에 전달된 텍스트를 플레이스홀더로 표시합니다.

아래 예시에서는 isEnabled에 변수를 바인딩하고, Toggle로 외부에서 관리해보겠습니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/16185584-78db-4804-8134-f409e596f1d9">

<br><br>

만약에 따로 비활성화 하는 경우가 없다면 `.constant()`로 전달하고, `disabledPlaceholder`에는 빈 문자열을 전달하면 됩니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: .constant(true),
    disabledPlaceholder: "",
    regExpUse: .none)
```

<br><br>

### 정규식 사용

`regExpUse` 열거형으로 정규식 사용 여부를 결정할 수 있습니다.

사용하지 않는다면 `none`, 사용한다면 `use`를 주입하면 됩니다.

`use`에는 연관값으로 `pattern`과 `isMatched`를 전달할 수 있습니다.

`pattern` 텍스트와 비교할 정규식 패턴 문자열입니다.

`isMatched`는 외부에서 바인딩 받는 변수로, 내부에서 정규식 일치 여부를 업데이트 받습니다.

아래 예시에서는 이메일 패턴을 전달해보겠습니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .use(
        pattern: #"^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,3}+$"#,
        isMatched: $isMatched))
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/4e70d296-e5ca-464c-962e-0d09f01a8409">

<br><br>

### 포커스 관리

`@FocusState`를 패키지 내부에 포함시키면 최소 지원버전이 **iOS 15**로 올라가기 때문에 포함시키지 않았습니다.

트레이드 오프를 생각해봤을 때, 파라미터로 전달받는 사용성보다 지원 버전을 낮추는게 더 메리트가 있다고 생각했습니다.

프로젝트 지원 버전이 15.0+인 사용자분들은 외부에서 `FocusState`를 사용해서 포커스를 관리할 수 있습니다.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
.focused($isFocus)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/57bb4b94-5e73-4e69-ba99-a620b04b741c">

<br><br>

# 라이센스

`AutoHeightEditor`는 MIT 라이센스의 범위 내에서 사용 가능합니다.

자세한 정보는 [라이센스](https://github.com/wontaeyoung/AutoHeightEditor/blob/main/LICENSE)에서 확인해주세요.
