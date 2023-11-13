[![Platform](https://img.shields.io/badge/Platform-iOS_iPadOS-orange.svg)](https://developer.apple.com/ios/)
[![Deployments](https://img.shields.io/badge/Deployments-14.0+-skyblue.svg)](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-14-release-notes)
[![UseFor](https://img.shields.io/badge/UseFor-SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-khaki.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/wontaeyoung/AutoHeightEditor/blob/main/LICENSE)
[![Github](https://img.shields.io/badge/Author-wontaeyoung-red.svg)](https://www.github.com/wontaeyoung)

`AutoHeightEditor`는 Dynamic Height 기능이 있는 커스텀 `TextEditor` 라이브러리입니다. 

# 제작 배경

이 라이브러리는 제가 프로젝트에 필요해서 직접 구현하게 된 커스텀 텍스트에디터를 라이브러리에 형태로 수정해서 공유하게 되었습니다.

제가 진행하고 있는 프로젝트에서 동적으로 높이가 조절되는 입력 인터페이스가 요구사항이었는데, iOS 16부터는 `TextField`의 `axis` 파라미터를 통해 Dynamic Height로 동작하는 입력 인터페이스를 사용할 수 있습니다.

하지만 프로젝트 최소 지원버전이 iOS 15.0+로 결정되었고, 여러 줄의 텍스트 입력을 받기 위해서는 `TextEditor`를 사용해야했습니다.

기본 API로 제공되는 `TextEditor`를 사용해보면 별도로 높이를 지정해주지 않으면 차지할 수 있는 최대 높이를 가지게 됩니다.

이를 해결하기 위해서 폰트 높이, 행간, 텍스트 길이, 개행문자를 통해서 적절한 높이를 동적으로 계산해주는 `AutoHeightEditor`를 커스텀으로 제작하게 되었습니다.

자세한 제작 배경 및 구현 과정은 [블로그](https://velog.io/@wontaeyoung/swiftui4)에서 확인할 수 있습니다.
