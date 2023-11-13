[![Platform](https://img.shields.io/badge/Platform-iOS_iPadOS-orange.svg)](https://developer.apple.com/ios/)
[![Deployments](https://img.shields.io/badge/Deployments-14.0+-skyblue.svg)](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-14-release-notes)
[![UseFor](https://img.shields.io/badge/UseFor-SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-khaki.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/wontaeyoung/AutoHeightEditor/blob/main/LICENSE)
[![Github](https://img.shields.io/badge/Author-wontaeyoung-red.svg)](https://www.github.com/wontaeyoung)

`AutoHeightEditor`는 Dynamic Height 기능이 있는 커스텀 `TextEditor` 라이브러리입니다. 

<br>

# 제작 배경

이 라이브러리는 제가 프로젝트에 필요해서 직접 구현하게 된 커스텀 텍스트에디터를 라이브러리에 형태로 수정해서 공유하게 되었습니다.

제가 진행하고 있는 프로젝트에서 동적으로 높이가 조절되는 입력 인터페이스가 요구사항이었는데, iOS 16부터는 `TextField`의 `axis` 파라미터를 통해 Dynamic Height로 동작하는 입력 인터페이스를 사용할 수 있습니다.

하지만 프로젝트 최소 지원버전이 iOS 15.0+로 결정되었고, 여러 줄의 텍스트 입력을 받기 위해서는 `TextEditor`를 사용해야했습니다.

기본 API로 제공되는 `TextEditor`를 사용해보면 별도로 높이를 지정해주지 않으면 차지할 수 있는 최대 높이를 가지게 됩니다.

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
